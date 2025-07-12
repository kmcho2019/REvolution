// Define the states as an enum
`define STATE_A 2'b00
`define STATE_B 2'b01
`define STATE_C 2'b10
`define STATE_D 2'b11

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [1:0] state, nextState;

// Output logic (Moore machine, output depends only on state)
always @(*)
    case(state)
        `STATE_A, `STATE_B, `STATE_C: out = 1'b0;
        `STATE_D: out = 1'b1;
        default: out = 1'b0; // Default to 0 for invalid states
    endcase

// Next state logic
always @(posedge clk)
begin
    if (reset) begin // Synchronous active-high reset
        state <= `STATE_A;
    end else begin
        case(state)
            `STATE_A: state <= in ? `STATE_B : `STATE_A;
            `STATE_B: state <= in ? `STATE_B : `STATE_C;
            `STATE_C: state <= in ? `STATE_D : `STATE_A;
            `STATE_D: state <= in ? `STATE_B : `STATE_C;
            default: state <= `STATE_A; // Default to state A for invalid states
        endcase
    end
end

endmodule