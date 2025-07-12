module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

// LUT to encode next state and output
reg [1:0] lut[1:0]; // Next state (1 bit) and output (1 bit)
initial begin
    // B (out=1) --in=0--> A
    // B (out=1) --in=1--> B
    lut[0] = {STATE_A, 1'b0}; // in=0, next state=A, out=0
    lut[1] = {STATE_B, 1'b1}; // in=1, next state=B, out=1
    // A (out=0) --in=0--> B
    // A (out=0) --in=1--> A
    lut[2] = {STATE_B, 1'b1}; // in=0, next state=B, out=1
    lut[3] = {STATE_A, 1'b0}; // in=1, next state=A, out=0
end

reg state; // Current state
always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Reset to state B
    end else begin
        // Use LUT to determine next state and output
        case({state, in})
            2'b00: begin state <= lut[0][1]; out <= lut[0][0]; end
            2'b01: begin state <= lut[1][1]; out <= lut[1][0]; end
            2'b10: begin state <= lut[2][1]; out <= lut[2][0]; end
            2'b11: begin state <= lut[3][1]; out <= lut[3][0]; end
        endcase
    end
end

endmodule