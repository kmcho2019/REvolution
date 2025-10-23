module TopModule (
    input        clk,
    input        areset,
    input        predict_valid,
    input        predict_taken,
    input        train_mispredicted,
    input        train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Rollback: load history before mispredicted branch plus actual branch result at LSB
            predict_history <= {train_taken, train_history[31:1]};
        end else if (predict_valid) begin
            // Shift in predicted outcome at LSB; shift out oldest bit at MSB
            predict_history <= {predict_history[31:1], predict_taken};
        end
        // else hold current history
    end

endmodule