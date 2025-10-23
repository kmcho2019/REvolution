module LFSR #(parameter WIDTH = 4) (
    input clk,
    input rst,
    output reg [WIDTH-1:0] out
);

// Feedback calculation (XOR of MSB and second MSB, then inverted)
wire feedback = ~(out[WIDTH-1] ^ out[WIDTH-2]);

// Sequential logic for register update
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= {WIDTH{1'b0}};  // Reset to all zeros
    end else begin
        out <= {out[WIDTH-2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule