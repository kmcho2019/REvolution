module ring_counter #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire reset,
    input wire enable,    // Optional enable signal
    output reg [WIDTH-1:0] out
);

localparam INIT_STATE = {{WIDTH-1{1'b0}}, 1'b1};  // One-hot initial state

always @(posedge clk) begin
    if (reset) begin
        out <= INIT_STATE;
    end else if (enable) begin
        out <= {out[WIDTH-2:0], out[WIDTH-1]};  // Circular shift
    end
end

endmodule