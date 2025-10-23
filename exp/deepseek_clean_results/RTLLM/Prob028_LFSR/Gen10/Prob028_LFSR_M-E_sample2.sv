module LFSR (
    input clk,            // Clock input
    input rst,            // Active high reset
    input poly_sel,       // Feedback polynomial select (0: default, 1: alternate)
    output reg [3:0] out, // Standard binary output
    output reg [3:0] gray // Gray code output
);

// Internal next state calculation
wire [3:0] next_state;

// Feedback polynomial options
wire feedback_default = ~(out[3] ^ out[2]);
wire feedback_alternate = ~(out[3] ^ out[1]);

// Select feedback polynomial
wire feedback = poly_sel ? feedback_alternate : feedback_default;

// Parallel next state calculation
assign next_state = {out[2:0], feedback};

// Gray code conversion
always @(*) begin
    gray[3] = out[3];
    gray[2] = out[3] ^ out[2];
    gray[1] = out[2] ^ out[1];
    gray[0] = out[1] ^ out[0];
end

// Dual-edge triggered state update with self-correction
always @(posedge clk or negedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0001;
    end else begin
        out <= (next_state == 4'b0000) ? 4'b0001 : next_state;
    end
end

endmodule