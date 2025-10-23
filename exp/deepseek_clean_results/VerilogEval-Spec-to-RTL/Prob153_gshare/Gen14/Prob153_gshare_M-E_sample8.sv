module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // Dual GHR state: speculative and confirmed
    reg [6:0] ghr_spec;  // Speculative GHR (updated during prediction)
    reg [6:0] ghr_conf;  // Confirmed GHR (updated during training)
    
    // Dual-port PHT (128x2 bits)
    reg [1:0] pht [0:127];
    
    // Prediction path (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr_spec;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr_spec;
    
    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] next_counter_state;
    
    // Next state logic for saturating counters
    assign next_counter_state = 
        (pht[train_index] == 2'b00) ? (train_taken ? 2'b01 : 2'b00) :
        (pht[train_index] == 2'b01) ? (train_taken ? 2'b10 : 2'b00) :
        (pht[train_index] == 2'b10) ? (train_taken ? 2'b11 : 2'b01) :
                                      (train_taken ? 2'b11 : 2'b10);
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize both GHRs to 0
            ghr_spec <= 7'b0;
            ghr_conf <= 7'b0;
            
            // Initialize PHT to weakly not-taken
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end else begin
            // Training updates (highest priority)
            if (train_valid) begin
                // Update PHT
                pht[train_index] <= next_counter_state;
                
                // On misprediction, roll back GHR
                if (train_mispredicted) begin
                    ghr_conf <= {train_history[5:0], train_taken};
                    ghr_spec <= {train_history[5:0], train_taken};
                end
            end
            
            // Speculative GHR update (lower priority)
            if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr_spec <= {ghr_spec[5:0], predict_taken};
            end
            
            // Confirmed GHR update (when no misprediction)
            if (!(train_valid && train_mispredicted)) begin
                ghr_conf <= ghr_spec;
            end
        end
    end

endmodule