module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history_reg;
    reg [31:0] next_history_stage1;
    reg [31:0] next_history_final;
    wire clock_enable;

    // Clock gating logic
    assign clock_enable = predict_valid | train_mispredicted;

    // First stage: Handle misprediction case (highest priority)
    always @(*) begin
        if (train_mispredicted) begin
            next_history_stage1 = {train_history[30:0], train_taken};
        end else begin
            next_history_stage1 = history_reg;
        end
    end

    // Second stage: Handle prediction case
    always @(*) begin
        if (predict_valid && !train_mispredicted) begin
            next_history_final = {next_history_stage1[30:0], predict_taken};
        end else begin
            next_history_final = next_history_stage1;
        end
    end

    // Sequential state update with clock gating
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (clock_enable) begin
            history_reg <= next_history_final;
        end
    end

    assign predict_history = history_reg;

endmodule