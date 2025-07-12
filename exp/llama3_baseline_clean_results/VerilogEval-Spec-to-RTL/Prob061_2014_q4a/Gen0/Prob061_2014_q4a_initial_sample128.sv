module TopModule(
    input clk,
    input w,  // input from previous stage
    input R,  // value to load
    input E,  // enable shift
    input L,  // load enable
    output Q   // current value
);

reg q;  // internal signal to store the current value
assign Q = q;  // assign the internal signal to the output

always @(posedge clk) begin
    if (L) begin
        // if load is asserted, load the new value
        q <= R;
    end else if (E) begin
        // if shift is enabled, shift in the value from the previous stage
        q <= w;
    end else begin
        // if neither load nor shift is enabled, maintain the current value
        q <= q;
    end
end

endmodule