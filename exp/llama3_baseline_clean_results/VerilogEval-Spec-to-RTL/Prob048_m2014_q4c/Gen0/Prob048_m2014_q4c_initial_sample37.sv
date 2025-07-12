module TopModule(
    input clk, // clock input
    input d,   // data input
    input r,   // reset input
    output q   // data output
);

reg q_reg; // internal register to hold the output value
assign q = q_reg; // assign the internal register to the output

always @ (posedge clk) // clock edge sensitivity
begin
    if (r) // if reset is high
        q_reg <= 1'b0; // reset output to 0
    else
        q_reg <= d; // otherwise, set output to data input
end

endmodule