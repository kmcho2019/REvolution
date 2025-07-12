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

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];
    
    // Prediction is combinational
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    
    // PHT update logic with arithmetic and saturation
    wire [1:0] next_pht_state;
    assign next_pht_state = 
        train_taken ? (pht[train_index] == 2'b11 ? 2'b11 : pht[train_index] + 1)
                   : (pht[train_index] == 2'b00 ? 2'b00 : pht[train_index] - 1);
    
    // GHR update logic - training has priority
    wire ghr_update_needed = (train_valid && train_mispredicted) || predict_valid;
    wire [6:0] next_ghr = (train_valid && train_mispredicted) ? {train_history[5:0], train_taken}
                                                             : {ghr[5:0], predict_taken};
    
    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update PHT if training
            if (train_valid) begin
                pht[train_index] <= next_pht_state;
            end
            
            // Update GHR only when needed
            if (ghr_update_needed) begin
                ghr <= next_ghr;
            end
        end
    end

endmodule