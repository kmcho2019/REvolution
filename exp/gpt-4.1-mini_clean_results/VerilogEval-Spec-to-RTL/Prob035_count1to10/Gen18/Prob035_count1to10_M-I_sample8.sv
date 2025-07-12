module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // Sequential logic with synchronous reset and wrap-around
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;               // synchronous reset to 1
        end else if (q == 4'd10) begin
            q <= 4'd1;               // wrap from 10 back to 1
        end else begin
            q <= q + 4'd1;           // increment otherwise
        end
    end

endmodule