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

    // Function to update saturating counter (from Example 1)
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            if (taken) begin
                update_counter = (current == 2'b11) ? 2'b11 : current + 1;
            end else begin
                update_counter = (current == 2'b00) ? 2'b00 : current - 1;
            end
        end
    endfunction

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Gated XOR operations for power optimization
    wire [6:0] predict_index = predict_valid ? (predict_pc ^ ghr) : 7'b0;
    wire [6:0] train_index = train_valid ? (train_pc ^ train_history) : 7'b0;

    // Immediate combinational prediction (from Example 2)
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;

    // PHT update logic (separate always block from Example 1)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Compact PHT reset (from Example 2)
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else if (train_valid) begin
            // Use function for counter update (from Example 1)
            pht[train_index] <= update_counter(pht[train_index], train_taken);
        end
    end

    // Optimized GHR update logic (simplified priority from Example 2)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else if (train_valid && train_mispredicted) begin
            ghr <= {train_history[5:0], train_taken};
        end else if (predict_valid) begin
            ghr <= {ghr[5:0], predict_taken};
        end
    end

endmodule