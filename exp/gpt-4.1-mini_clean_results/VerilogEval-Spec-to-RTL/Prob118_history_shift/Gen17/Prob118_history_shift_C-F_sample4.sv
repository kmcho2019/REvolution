module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0] predict_history
);

    wire update_enable = predict_valid | train_mispredicted;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            if (train_mispredicted) begin
                // Roll back history: concatenate train_history shifted right by 1 bit with train_taken at LSB
                predict_history <= {train_history[30:0], train_taken};
            end else begin
                // Normal prediction update: shift history left, insert predict_taken at LSB
                predict_history <= {predict_history[30:0], predict_taken};
            end
        end
        // else hold current predict_history value to reduce toggling
    end

endmodule