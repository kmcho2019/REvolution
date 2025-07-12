module right_shifter #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire reset_n,    // Active-low synchronous reset
    input wire enable,     // Shift enable
    input wire d,          // Input bit
    output reg [WIDTH-1:0] q
);

// Next state logic
wire [WIDTH-1:0] next_q;
assign next_q = enable ? {d, q[WIDTH-1:1]} : q;

// Sequential logic
always @(posedge clk) begin
    if (!reset_n) begin
        q <= {WIDTH{1'b0}};  // Synchronous reset
    end else begin
        q <= next_q;        // Update register
    end
end

endmodule