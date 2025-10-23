module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

    reg latch_out;

    // Asynchronous reset implemented via latch: when ar=1, latch_out=0 asynchronously
    always @(*) begin
        if (ar)
            latch_out = 1'b0;   // Force low immediately on ar
        else
            latch_out = d;      // Pass input d through latch when reset inactive
    end

    // D Flip-Flop capturing latch output synchronously on posedge clk
    always @(posedge clk) begin
        q <= latch_out;
    end

endmodule