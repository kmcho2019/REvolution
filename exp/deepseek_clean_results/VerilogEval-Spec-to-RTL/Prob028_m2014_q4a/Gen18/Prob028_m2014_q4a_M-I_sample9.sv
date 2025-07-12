module TopModule(
    input d,
    input ena,
    output reg q
);
    // D latch with asynchronous reset (active low)
    always_latch begin
        if (!ena) begin
            q <= q;  // Hold state when not enabled
        end else begin
            q <= d;  // Transparent when enabled
        end
    end
endmodule