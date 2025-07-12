module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

    // q cycles modulo 7: 0..6
    // On rising edge, if a=1, q <= 4; else q <= (q + 1) mod 7;

    always @(posedge clk) begin
        if (a)
            q <= 3'd4;
        else
            // Modular increment mod 7 implemented as:
            // If q == 6 then 0 else q+1
            // Avoid explicit comparator using arithmetic:
            // q + 1 wraps naturally at 7 due to 3-bit, so force wrap manually:
            q <= (q == 3'd6) ? 3'd0 : q + 3'd1;
    end

endmodule