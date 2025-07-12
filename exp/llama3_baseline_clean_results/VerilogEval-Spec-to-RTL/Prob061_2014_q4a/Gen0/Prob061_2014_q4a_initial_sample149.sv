module TopModule(
    input  clk,  // clock signal
    input  w,   // input from previous stage
    input  R,   // value to load
    input  E,   // enable shift
    input  L,   // load signal
    output Q    // output
);

reg q_reg;  // internal register to hold the output
assign Q = q_reg;

always @(posedge clk) begin
    if (L) begin  // if load signal is asserted
        q_reg <= R;  // load the value
    end else if (E) begin  // if shift is enabled
        q_reg <= w;  // shift in the value from previous stage
    end
end

endmodule