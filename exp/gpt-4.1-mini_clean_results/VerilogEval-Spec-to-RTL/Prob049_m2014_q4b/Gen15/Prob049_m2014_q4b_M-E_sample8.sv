module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

    // Asynchronous reset logic: when ar is high, q is reset immediately
    always @(ar) begin
        if (ar)
            q <= 1'b0;
    end

    // Synchronous data capture on positive clock edge, only if not in reset
    always @(posedge clk) begin
        if (!ar)
            q <= d;
    end

endmodule