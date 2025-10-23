module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg q; // Register to store the state

always @(posedge clk) begin
    if (L) begin // Load operation
        q <= R;
    end else if (E) begin // Shift operation
        q <= w;
    end
end

assign Q = q; // Output the current state

endmodule