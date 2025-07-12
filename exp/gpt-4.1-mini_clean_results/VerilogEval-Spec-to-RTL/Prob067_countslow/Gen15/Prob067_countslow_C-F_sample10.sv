module TopModule(
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    // count_enable only when slowena is high (separate from reset)
    wire count_enable = slowena;

    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else if (count_enable)
            q <= (q == 4'd9) ? 4'd0 : q + 1;
        // else hold q
    end

endmodule