module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// Create a 3-bit index combining current state and input
wire [2:0] state_input_index = {state, in};

always @(*) begin
    case (state_input_index)
        // State A (00) cases
        3'b000: begin next_state = 2'b00; out = 1'b0; end // A, in=0 -> A
        3'b001: begin next_state = 2'b01; out = 1'b0; end // A, in=1 -> B
        
        // State B (01) cases
        3'b010: begin next_state = 2'b10; out = 1'b0; end // B, in=0 -> C
        3'b011: begin next_state = 2'b01; out = 1'b0; end // B, in=1 -> B
        
        // State C (10) cases
        3'b100: begin next_state = 2'b00; out = 1'b0; end // C, in=0 -> A
        3'b101: begin next_state = 2'b11; out = 1'b0; end // C, in=1 -> D
        
        // State D (11) cases
        3'b110: begin next_state = 2'b10; out = 1'b1; end // D, in=0 -> C
        3'b111: begin next_state = 2'b01; out = 1'b1; end // D, in=1 -> B
        
        default: begin next_state = 2'b00; out = 1'b0; end // Fallback to state A
    endcase
end

endmodule