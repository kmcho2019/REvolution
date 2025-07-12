module TopModule(
    input clk,
    input rst_n,  // Asynchronous active-low reset
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        q <= 8'd0;  // Initialize q to 0 on reset
    end else begin
        q <= d;
    end
end

endmodule