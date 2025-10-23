module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    wire update_enable = train_mispredicted | predict_valid;
    reg [31:0] next_history;

    always @* begin
        if (train_mispredicted)
            next_history = {train_history, train_taken};
        else if (predict_valid)
            next_history = {predict_history[30:0], predict_taken};
        else
            next_history = predict_history;  // hold state if no update
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            predict_history <= next_history;
        end
    end

endmodule