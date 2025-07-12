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

    reg [31:0] next_history;

    always @(*) begin
        if (train_mispredicted) begin
            // Rollback to history before mispredicted branch + actual outcome
            next_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift in predicted taken bit
            next_history = {predict_history[30:0], predict_taken};
        end else begin
            // Hold current state
            next_history = predict_history;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else
            predict_history <= next_history;
    end

endmodule