module TopModule(
    input  clk,
    input  d,
    input  r,
    output q
);

reg q_reg; // internal register to store the output
assign q = q_reg; // assign the internal register to the output

always @(posedge clk) // clock edge detection
begin
    if (r) // if reset is high
    begin
        q_reg <= 1'b0; // reset the output to 0
    end
    else // if reset is not high
    begin
        q_reg <= d; // capture the input data
    end
end

endmodule