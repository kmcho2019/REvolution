module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;           // synchronous reset sets count to 1
        else if (q == 4'd10)
            q <= 4'd1;           // rollover from 10 back to 1
        else
            q <= q + 1'b1;       // increment count
    end

endmodule