// Define the states
`define STATE_A 2'b00
`define STATE_B 2'b01
`define STATE_C 2'b10
`define STATE_D 2'b11

module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] currentState;
reg [1:0] nextState;
reg outReg;

always @ (posedge clk) begin
    if (reset) begin
        currentState <= `STATE_A;
        outReg <= 0;
    end else begin
        currentState <= nextState;
        case(currentState)
            `STATE_A: outReg <= 0;
            `STATE_B: outReg <= 0;
            `STATE_C: outReg <= 0;
            `STATE_D: outReg <= 1;
        endcase
    end
end

always @ (*) begin
    case(currentState)
        `STATE_A: nextState = in ? `STATE_B : `STATE_A;
        `STATE_B: nextState = in ? `STATE_B : `STATE_C;
        `STATE_C: nextState = in ? `STATE_D : `STATE_A;
        `STATE_D: nextState = in ? `STATE_B : `STATE_C;
    endcase
end

assign out = outReg;

endmodule