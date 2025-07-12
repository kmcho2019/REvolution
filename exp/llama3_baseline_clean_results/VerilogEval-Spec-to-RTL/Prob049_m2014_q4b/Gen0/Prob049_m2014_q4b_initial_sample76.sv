module TopModule(
    input  clk,  // clock signal
    input  ar,   // asynchronous reset signal
    input  d,    // data input
    output q     // data output
);

reg q_reg;  // internal register to hold the output value

always @(posedge clk or posedge ar) begin
    if (ar) begin
        // asynchronous reset: set q to 0 immediately
        q_reg <= 1'b0;
    end else begin
        // on positive clock edge, capture the input 'd'
        q_reg <= d;
    end
end

assign q = q_reg;  // assign the internal register to the output

endmodule