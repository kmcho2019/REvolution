module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

// Define the states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;
parameter S6 = 3'b110;
parameter S7 = 3'b111;

reg [2:0] state;
reg [2:0] nextState;

// Outputs
reg discReg;
reg flagReg;
reg errReg;

assign disc = discReg;
assign flag = flagReg;
assign err = errReg;

always @(*) begin
    discReg = 1'b0;
    flagReg = 1'b0;
    errReg = 1'b0;
    
    case (state)
        S5: if (~in) discReg = 1'b1;
        S6: flagReg = 1'b1;
        S7: errReg = 1'b1;
    endcase
end

always @(*) begin
    case (state)
        S0: if (in) nextState = S1; else nextState = S0;
        S1: if (in) nextState = S2; else nextState = S0;
        S2: if (in) nextState = S3; else nextState = S0;
        S3: if (in) nextState = S4; else nextState = S0;
        S4: if (in) nextState = S5; else nextState = S0;
        S5: if (in) nextState = S6; else nextState = Sdisc;
        S6: if (in) nextState = S7; else nextState = S0;
        S7: if (in) nextState = S7; else nextState = S0;
        default: nextState = S0;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        discReg <= 1'b0;
        flagReg <= 1'b0;
        errReg <= 1'b0;
    end else begin
        state <= nextState;
    end
end

endmodule