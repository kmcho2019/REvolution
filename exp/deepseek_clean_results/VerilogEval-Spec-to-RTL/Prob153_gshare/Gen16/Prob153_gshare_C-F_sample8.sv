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

    // Single GHR with speculative tracking
    reg [6:0] ghr;
    reg [6:0] ghr_next;
    
    // Dual-port PHT (128x2 bits)
    reg [1:0] pht [0:127];
    
    // Prediction path
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;
    
    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] next_counter_state;
    
    // Optimized saturation counter logic
    assign next_counter_state = 
        train_taken ? (pht[train_index] == 2'b11 ? 2'b11 : pht[train_index] + 1)
                    : (pht[train_index] == 2'b00 ? 2'b00 : pht[train_index] - 1);
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            ghr_next <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Handle training first (highest priority)
            if (train_valid) begin
                // Update PHT
                pht[train_index] <= next_counter_state;
                
                // On misprediction, roll back GHR
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                    ghr_next <= {train_history[5:0], train_taken};
                end else begin
                    ghr <= ghr_next;
                end
            end else begin
                ghr <= ghr_next;
            end
            
            // Handle prediction updates
            if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr_next <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule