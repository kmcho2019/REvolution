module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_count = q + 1'b1;  // Pre-compute increment in parallel

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // Direct assignment when a=1
    end else begin
        q <= (q == 3'd6) ? 3'd0 : next_count;  // Increment with wrap-around
    end
end

endmodule