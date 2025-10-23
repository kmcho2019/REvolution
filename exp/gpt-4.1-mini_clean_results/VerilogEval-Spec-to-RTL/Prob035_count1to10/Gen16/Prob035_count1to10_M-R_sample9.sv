module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    localparam MAX_COUNT = 4'd10;
    localparam MIN_COUNT = 4'd1;

    always @(posedge clk) begin
        if (reset) begin
            q <= MIN_COUNT;  // Synchronous reset to 1
        end else begin
            q <= (q == MAX_COUNT) ? MIN_COUNT : q + 1'b1;  // Increment or wrap
        end
    end

endmodule