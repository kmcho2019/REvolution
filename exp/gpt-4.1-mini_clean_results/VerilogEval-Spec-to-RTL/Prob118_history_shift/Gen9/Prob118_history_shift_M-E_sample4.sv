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

    wire load = train_mispredicted;
    wire shift = predict_valid && !train_mispredicted; // rollback takes priority, so no shift on mispredicted

    reg [31:0] next_history;

    always @(*) begin
        if (load) begin
            // On rollback, load rollback history: train_history[30:0] concatenated with train_taken
            next_history = {train_history[30:0], train_taken};
        end else if (shift) begin
            // On valid prediction, shift history left and insert predict_taken at LSB
            next_history = {predict_history[30:0], predict_taken};
        end else begin
            // Hold current history
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