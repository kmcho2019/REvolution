module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg q; // Internal register
assign Q = q; // Output the internal register value

always @(posedge clk) begin
    if (L) begin // Load operation
        q <= R;
    end else if (E) begin // Shift operation
        q <= w;
    end
end

endmodule