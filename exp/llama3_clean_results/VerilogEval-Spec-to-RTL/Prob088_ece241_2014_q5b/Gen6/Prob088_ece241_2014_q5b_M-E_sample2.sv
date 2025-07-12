module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // One-hot encoding for state A (2'b01) and state B (2'b10)

// Lookup table for next state and output
reg [1:0] lut_next_state [1:0];
reg [0:0] lut_output [1:0];

initial begin
    // Initialize lookup table
    lut_next_state[0] = 2'b01; // Stay in A when x=0
    lut_next_state[1] = 2'b10; // Move to B when x=1
    lut_output[0] = 1'b0; // z=0 in state A
    lut_output[1] = 1'b1; // z=1 in state B
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
        z <= 1'b0; // Reset output to 0
    end else begin
        case({state, x})
            3'b001: begin state <= 2'b01; z <= 1'b0; end // A, x=0
            3'b011: begin state <= 2'b10; z <= 1'b1; end // A, x=1
            3'b101: begin state <= 2'b10; z <= 1'b1; end // B, x=0
            3'b111: begin state <= 2'b10; z <= 1'b0; end // B, x=1
        endcase
    end
end

endmodule