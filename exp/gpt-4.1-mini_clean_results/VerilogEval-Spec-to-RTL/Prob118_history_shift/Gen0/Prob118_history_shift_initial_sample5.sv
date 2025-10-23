module TopModule(
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
        // Load history before mispredicted branch concatenated with actual branch outcome
        predict_history <= {train_history[30:0], train_taken};
    end else if (predict_valid) begin
        // Shift in the prediction result at LSB side
        predict_history <= {predict_history[31:1], predict_taken};
    end
    // else hold current predict_history
end

endmodule