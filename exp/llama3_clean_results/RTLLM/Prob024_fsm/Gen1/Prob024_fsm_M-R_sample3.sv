module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define states as parameters
parameter S0 = 3'b000, // Initial state
           S1 = 3'b001, // Received the first '1'
           S2 = 3'b010, // Received the first '0'
           S3 = 3'b011, // Received the second '0'
           S4 = 3'b100; // Received the first '1' after the zeros

// Current state register
logic [2:0] state;

// Always block for sequential logic
always_ff @(posedge CLK or posedge RST) begin
    if (RST) state <= S0; // Reset to initial state
    else
        case(state)
            S0: state <= IN? S1 : S0;
            S1: state <= IN? S1 : S2;
            S2: state <= IN? S1 : S3;
            S3: state <= IN? S4 : S0;
            S4: state <= IN? S4 : S0;
            default: state <= S0; // Invalid state, reset to S0
        endcase
end

// Continuous assignment for output MATCH
assign MATCH = (state == S4) && IN;

endmodule