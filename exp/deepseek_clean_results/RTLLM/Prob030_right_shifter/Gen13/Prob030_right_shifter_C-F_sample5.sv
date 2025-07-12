module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,    // Shift enable control
    input wire reset_n,   // Optional active-low reset
    output reg [7:0] q
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= 8'b0;        // Synchronous reset
    end
    else if (enable) begin
        q <= {d, q[7:1]}; // Efficient shift with enable
    end
end

endmodule