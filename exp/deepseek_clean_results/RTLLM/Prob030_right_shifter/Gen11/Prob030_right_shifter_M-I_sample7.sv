module right_shifter (
    input clk,
    input reset_n,    // Added active-low reset for initialization
    input d,
    output reg [7:0] q
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= 8'b0;    // Explicit reset
    end else begin
        q <= {d, q[7:1]};  // Maintain efficient shift operation
    end
end

endmodule