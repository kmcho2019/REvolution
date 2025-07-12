module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // states: S0, S1, S2, S3, S4, S5, S6, S7
reg [2:0] nextState;
reg discReg, flagReg, errReg;

always @(*) begin
    case(state)
        3'b000: // S0
            if(in)
                nextState = 3'b001; // S1
            else
                nextState = 3'b000; // S0
        3'b001: // S1
            if(in)
                nextState = 3'b010; // S2
            else
                nextState = 3'b000; // S0
        3'b010: // S2
            if(in)
                nextState = 3'b011; // S3
            else
                nextState = 3'b000; // S0
        3'b011: // S3
            if(in)
                nextState = 3'b100; // S4
            else
                nextState = 3'b000; // S0
        3'b100: // S4
            if(in)
                nextState = 3'b101; // S5
            else
                nextState = 3'b000; // S0
        3'b101: // S5
            if(in) begin
                discReg = 1'b1;
                nextState = 3'b000; // S0
            end else
                nextState = 3'b110; // S6
        3'b110: // S6
            if(in) begin
                errReg = 1'b1;
                nextState = 3'b111; // S7
            end else begin
                flagReg = 1'b1;
                nextState = 3'b000; // S0
            end
        3'b111: // S7
            if(in)
                nextState = 3'b111; // S7
            else
                nextState = 3'b000; // S0
        default:
            nextState = 3'b000; // S0
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 3'b000;
        discReg <= 1'b0;
        flagReg <= 1'b0;
        errReg <= 1'b0;
    end else begin
        state <= nextState;
        discReg <= disc;
        flagReg <= flag;
        errReg <= err;
    end
end

assign disc = discReg;
assign flag = flagReg;
assign err = errReg;

endmodule