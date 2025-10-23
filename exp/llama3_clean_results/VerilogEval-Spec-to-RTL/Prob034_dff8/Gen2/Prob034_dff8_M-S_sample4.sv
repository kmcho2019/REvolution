module TopModule(
    input clk,
    input rst_n, // Asynchronous reset
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 8'b0; // Initialize q to zero on reset
    end else begin
        q <= d;
    end
end

endmodule