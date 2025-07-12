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

    // Optimized PHT with clock gating
    reg [1:0] pht [0:127];
    wire [6:0] train_index = train_pc ^ train_history;
    wire [6:0] predict_index = predict_pc ^ predict_history;
    
    // Single GHR implementation
    reg [6:0] ghr;
    assign predict_history = ghr;
    assign predict_taken = pht[predict_index][1];
    
    // Counter update function (unchanged)
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            case (current)
                2'b00: update_counter = taken ? 2'b01 : 2'b00;
                2'b01: update_counter = taken ? 2'b10 : 2'b00;
                2'b10: update_counter = taken ? 2'b11 : 2'b01;
                2'b11: update_counter = taken ? 2'b11 : 2'b10;
            endcase
        end
    endfunction
    
    // Optimized GHR update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT with default value (weakly taken)
            for (integer i = 0; i < 128; i++) pht[i] <= 2'b01;
            ghr <= 7'b0;
        end else begin
            // PHT update with clock gating
            if (train_valid) begin
                pht[train_index] <= update_counter(pht[train_index], train_taken);
            end
            
            // Priority GHR update: training misprediction has highest priority
            casex ({train_valid && train_mispredicted, predict_valid})
                2'b1x:  ghr <= {train_history[5:0], train_taken};
                2'b01:  ghr <= {ghr[5:0], predict_taken};
                default: ghr <= ghr;  // No change
            endcase
        end
    end

endmodule