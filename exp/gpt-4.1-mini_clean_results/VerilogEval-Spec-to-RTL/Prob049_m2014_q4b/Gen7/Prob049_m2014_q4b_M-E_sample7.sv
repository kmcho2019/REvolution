module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

    // Asynchronous latch to hold reset state
    reg ar_latched;

    // Asynchronous latch: set when ar=1, reset when ar=0
    always @(*) begin
        if (ar)
            ar_latched = 1'b1;
        else
            ar_latched = 1'b0;
    end

    // D flip-flop with clock enable controlled by !ar_latched
    always @(posedge clk) begin
        if (ar_latched)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule