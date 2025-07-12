module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Enable counting only if q < 9
    wire count_en = (q < 4'd9);

    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else if (count_en)
            q <= q + 4'd1;
        else
            q <= q; // Hold count at 9 until reset
    end

endmodule