module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg q; // internal reg to store the current value
assign Q = q; // assign the internal reg to the output

always @(posedge clk) begin
    if (L) begin
        // load the value R if load signal is asserted
        q <= R;
    end else if (E) begin
        // shift the value from the previous stage if enable signal is asserted
        q <= w;
    end else begin
        // hold the current value if neither load nor enable signal is asserted
        q <= q;
    end
end

endmodule