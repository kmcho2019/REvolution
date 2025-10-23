module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg q_reg; // register to store the value
assign Q = q_reg; // assign the output Q to the register value

always @(posedge clk) begin
    if (L) begin
        // if load is asserted, load the value of R
        q_reg <= R;
    end else if (E) begin
        // if enable shift is asserted and load is not, shift in the value from the previous stage
        q_reg <= w;
    end
    // otherwise, retain the current value
end

endmodule