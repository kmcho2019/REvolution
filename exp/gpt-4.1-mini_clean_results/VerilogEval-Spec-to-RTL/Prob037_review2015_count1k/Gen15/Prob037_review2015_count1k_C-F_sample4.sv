module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    // Parameters for terminal count and wrap value
    localparam MAX_COUNT = 10'd999;
    localparam WRAP_VALUE = 10'd1000;

    // Compute next value
    wire [10:0] next_val = q + 11'd1;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else if (next_val == WRAP_VALUE) begin
            q <= 10'd0;
        end else begin
            q <= q + 10'd1;
        end
    end

endmodule