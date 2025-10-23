module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q // Declare 'q' as a reg
);

always @(posedge clk) begin
    q <= d; // Use non-blocking assignment to avoid potential race conditions
end

endmodule