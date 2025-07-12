module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] q_reg; // internal register to store the count
assign q = q_reg; // assign the internal register to the output

always @(posedge clk) begin
    if (reset) begin
        // if reset is high, reset the counter to 1
        q_reg <= 4'd1;
    end else if (q_reg == 4'd10) begin
        // if the counter reaches 10, wrap around to 1
        q_reg <= 4'd1;
    end else begin
        // otherwise, increment the counter
        q_reg <= q_reg + 1'd1;
    end
end

endmodule