module TopModule(
    input clk,
    input rst_n, // Active low reset signal
    input [7:0] d,
    output reg [7:0] q // Declare 'q' as a reg type
);

initial q = 8'b0; // Initialize 'q' to zero at power-on

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        q <= 8'b0; // Reset 'q' to zero on active low reset
    end else begin
        q <= d; // Update 'q' with 'd' on positive clock edge
    end
end

endmodule