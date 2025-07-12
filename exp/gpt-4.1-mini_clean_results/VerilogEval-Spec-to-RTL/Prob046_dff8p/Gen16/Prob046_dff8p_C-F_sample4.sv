module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output reg [7:0] q
);

    wire load = reset | (d != q);

    always @(negedge clk) begin
        if (reset) begin
            q <= 8'h34;
        end else if (load) begin
            q <= d;
        end
        // else q retains its value
    end

endmodule