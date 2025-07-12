module TopModule(
    input  clk, // clock signal
    input  d,   // data input
    input  r,   // reset signal
    output q    // data output
);

reg q_reg; // internal register to hold the output value
assign q = q_reg; // assign the internal register to the output

always @ (posedge clk) begin
    if (r) begin // if reset is high
        q_reg <= 1'b0; // reset the output to 0
    end else begin
        q_reg <= d; // load the data input into the output
    end
end

endmodule