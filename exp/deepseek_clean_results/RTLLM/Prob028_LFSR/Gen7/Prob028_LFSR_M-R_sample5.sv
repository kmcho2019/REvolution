module LFSR #(parameter WIDTH = 4) (
    input clk,
    input rst,
    output [WIDTH-1:0] out
);

reg [WIDTH-1:0] state;
wire feedback;

// Feedback is inverted XOR of MSB and second MSB
assign feedback = ~(state[WIDTH-1] ^ state[WIDTH-2]);

// Output is directly connected to state
assign out = state;

// State update logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= {WIDTH{1'b0}};  // Reset to all zeros
    end else begin
        // Shift left and insert feedback at LSB
        state <= {state[WIDTH-2:0], feedback};
    end
end

endmodule