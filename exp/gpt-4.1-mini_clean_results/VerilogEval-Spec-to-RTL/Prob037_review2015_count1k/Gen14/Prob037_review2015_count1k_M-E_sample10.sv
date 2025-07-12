module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    wire [10:0] increment_result;
    // Increment q by 1
    assign increment_result = {1'b0, q} + 11'd1;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else if (increment_result[10]) begin
            // Carry out from 10-bit addition indicates q was 999,
            // so wrap around to 0.
            q <= 10'd0;
        end else begin
            q <= increment_result[9:0];
        end
    end

endmodule