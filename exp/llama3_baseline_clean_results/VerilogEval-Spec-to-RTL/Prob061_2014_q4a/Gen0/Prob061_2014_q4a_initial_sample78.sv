module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg q_reg; // Internal register to hold the state
assign Q = q_reg; // Output is the current state of the register

always @ (posedge clk) begin
    if (L) begin // If load is asserted, load the value from R
        q_reg <= R;
    end else if (E) begin // If enable shift is asserted, shift in the value from w
        q_reg <= w;
    end
end

endmodule