module TopModule(
    input  clk,  // clock signal
    input  d,   // input data
    input  r,   // active high reset
    output q    // output data
);

reg q_reg;  // internal register to hold the output
assign q = q_reg;  // assign the internal register to the output

always @(posedge clk) begin
    if (r) begin  // if reset is high
        q_reg <= 0;  // set the output to 0
    end else begin
        q_reg <= d;  // assign the input to the output
    end
end

endmodule