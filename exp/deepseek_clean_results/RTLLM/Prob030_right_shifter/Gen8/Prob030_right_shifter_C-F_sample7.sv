module right_shifter (
    input wire clk,
    input wire reset_n,  // Active-low reset
    input wire d,
    output reg [7:0] q
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= 8'b0;       // Synchronous reset
    end else begin
        q <= {d, q[7:1]};  // Efficient right shift with new bit insertion
    end
end

endmodule