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
    
    // Combinational prediction
    assign predict_taken = predict_valid ? pht[predict_pc ^ ghr][1] : 1'b0;
    assign predict_history = ghr;

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;  // Weakly not-taken
        end else begin
            // Training has priority
            if (train_valid) begin
                // Update PHT
                if (train_taken)
                    pht[train_pc ^ train_history] <= (pht[train_pc ^ train_history] == 2'b11) ? 
                                                    2'b11 : pht[train_pc ^ train_history] + 1;
                else
                    pht[train_pc ^ train_history] <= (pht[train_pc ^ train_history] == 2'b00) ? 
                                                    2'b00 : pht[train_pc ^ train_history] - 1;
                
                // Update GHR if mispredicted
                if (train_mispredicted)
                    ghr <= {train_history[5:0], train_taken};
            end 
            // Otherwise update GHR for prediction
            else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule