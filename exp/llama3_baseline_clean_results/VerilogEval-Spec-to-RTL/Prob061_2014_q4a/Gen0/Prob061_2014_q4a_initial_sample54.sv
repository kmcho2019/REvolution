module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg q; // internal signal to hold the current value
assign Q = q; // assign the internal signal to the output

always @(posedge clk) begin
    if (L) begin // load operation
        q <= R;
    end else if (E) begin // shift operation
        q <= w;
    end else begin // hold the current value
        q <= q;
    end
end

endmodule