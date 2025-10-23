module TopModule (
    input        clk,
    input        j,
    input        k,
    output reg   Q
);

wire nextQ;
wire en;

assign nextQ = (j & ~k)        // Set
             | ((~j) & (~k) & Q) // Hold
             | (j & k & ~Q);   // Toggle

assign en = j | k; // Enable update only when state changes

always @(posedge clk) begin
    if (en)
        Q <= nextQ;
    // else retain previous Q (no clock gating, just skip update)
end

endmodule