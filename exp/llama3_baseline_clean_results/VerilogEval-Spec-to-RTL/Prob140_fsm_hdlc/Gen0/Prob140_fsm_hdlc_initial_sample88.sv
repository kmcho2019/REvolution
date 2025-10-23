module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3-bit state register
reg [2:0] nextState; // 3-bit next state register

// Define the states
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;
localparam S6 = 3'b110;
localparam S7 = 3'b111;

// Output logic
assign disc = (state == S5) ? 1'b1 : 1'b0;
assign flag = (state == S6) ? 1'b1 : 1'b0;
assign err = (state == S7) ? 1'b1 : 1'b0;

// Next state logic
always @(*) begin
    case(state)
        S0: if (in) nextState = S1; else nextState = S0;
        S1: if (in) nextState = S2; else nextState = S0;
        S2: if (in) nextState = S3; else nextState = S0;
        S3: if (in) nextState = S4; else nextState = S0;
        S4: if (in) nextState = S5; else nextState = S0;
        S5: if (in) nextState = S6; else nextState = S0; // Discard next 0
        S6: if (in) nextState = S7; else nextState = S0; // Flag next 0
        S7: if (in) nextState = S7; else nextState = S0; // Stay in error state
        default: nextState = S0;
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) state <= S0;
    else state <= nextState;
end

endmodule