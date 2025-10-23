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

    reg [31:0] next_predict_history;
    wire       update_enable;

    assign update_enable = train_mispredicted | predict_valid;

    always @(*) begin
        if (train_mispredicted) begin
            // Concatenate train_history[30:0] with train_taken at LSB
            next_predict_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift left and insert predict_taken at LSB
            next_predict_history = {predict_history[30:0], predict_taken};
        end else begin
            // Hold current state to avoid toggling
            next_predict_history = predict_history;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            predict_history <= next_predict_history;
        end
        // else hold value to reduce switching
    end

endmodule