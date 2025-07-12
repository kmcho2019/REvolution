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
    reg [31:0] next_history;

    // Combinational next-state logic
    always @(*) begin
        if (train_mispredicted) begin
            next_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            next_history = {history_reg[30:0], predict_taken};
        end else begin
            next_history = history_reg;
        end
    end

    // Sequential state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else begin
            history_reg <= next_history;
        end
    end

    assign predict_history = history_reg;

endmodule