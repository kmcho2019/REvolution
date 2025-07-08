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

// Asynchronous reset and synchronous updates on posedge clk
always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_history <= 32'b0;
    end else begin
        if (train_mispredicted) begin
            // Load history before mispredicted branch plus actual outcome
            // train_history is the history before mispredicted branch (oldest 32 bits)
            // train_taken is actual result of the mispredicted branch (LSB)
            predict_history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift in predict_taken into LSB, older history shifted right
            predict_history <= {predict_history[31:1], predict_taken};
        end
        // else hold current predict_history
    end
end

endmodule