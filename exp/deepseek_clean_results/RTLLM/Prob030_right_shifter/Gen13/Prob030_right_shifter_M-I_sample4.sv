module right_shifter (
    input wire clk,
    input wire d,
    input wire reset_n = 1'b1,  // Optional active-low reset (default inactive)
    output reg [7:0] q = 8'b0   // Initialization with default value
);

always @(posedge clk) begin
    if (!reset_n) begin
        q <= 8'b0;            // Synchronous reset when active
    end else begin
        q <= {d, q[7:1]};     // Efficient right shift with MSB insertion
    end
end

endmodule