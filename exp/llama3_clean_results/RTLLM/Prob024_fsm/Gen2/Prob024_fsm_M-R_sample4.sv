module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// State register
logic [1:0] state;

// Always block for sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) state <= 2'b00; // Reset to initial state
    else begin
        case(state)
            2'b00: state <= IN ? 2'b01 : 2'b00; // Initial state
            2'b01: state <= IN ? 2'b01 : 2'b10; // Received the first '1'
            2'b10: state <= IN ? 2'b01 : 2'b11; // Received the first '0'
            2'b11: state <= IN ? 2'b01 : 2'b00; // Received the second '0'
            default: state <= 2'b00; // Invalid state, reset to initial state
        endcase
    end
end

// Continuous assignment for output MATCH
assign MATCH = (state == 2'b01) && IN && (IN === 1'b1);

endmodule