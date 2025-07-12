module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

localparam RESET_VALUE = 3'd4;
localparam MAX_VALUE = 3'd6;

always @(posedge clk) begin
    if (a) begin
        q <= RESET_VALUE;  // synchronous reset when a=1
    end else begin
        // More efficient increment with wrap-around
        q <= (q + 1) % (MAX_VALUE + 1);
    end
end

endmodule