module TopModule (
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input   [31:0]   train_history,
    output  [31:0]   predict_history
);

reg [31:0] buffer;
reg [4:0] counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        buffer <= 32'd0;
        counter <= 5'd0;
    end else if (train_mispredicted) begin
        buffer <= {train_history, train_taken};
        counter <= 5'd0;
    end else if (predict_valid) begin
        buffer <= (buffer >> 1) | (predict_taken << 31);
        counter <= counter + 5'd1;
    end else begin
        buffer <= buffer;
        counter <= counter;
    end
end

assign predict_history = buffer;

endmodule