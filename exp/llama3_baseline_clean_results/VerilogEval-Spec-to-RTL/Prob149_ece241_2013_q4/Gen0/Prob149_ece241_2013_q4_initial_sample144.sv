module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] currentState;
reg [2:0] nextState;
reg [2:0] previousState;
reg fr2Reg, fr1Reg, fr0Reg, dfrReg;

// Define states
parameter STATE_BELOW_S0 = 3'b000;
parameter STATE_BELOW_S1 = 3'b001;
parameter STATE_BELOW_S2 = 3'b010;
parameter STATE_ABOVE_S2 = 3'b111;

// Initialize state machine
initial begin
    currentState = STATE_BELOW_S0;
    previousState = STATE_BELOW_S0;
    fr2Reg = 1'b1;
    fr1Reg = 1'b1;
    fr0Reg = 1'b1;
    dfrReg = 1'b1;
end

// State machine logic
always @(*) begin
    case(currentState)
        STATE_BELOW_S0: begin
            if (s[0]) begin
                nextState = STATE_BELOW_S1;
            end else begin
                nextState = STATE_BELOW_S0;
            end
        end
        STATE_BELOW_S1: begin
            if (s[1]) begin
                nextState = STATE_BELOW_S2;
            end else if (!s[0]) begin
                nextState = STATE_BELOW_S0;
            end else begin
                nextState = STATE_BELOW_S1;
            end
        end
        STATE_BELOW_S2: begin
            if (s[2]) begin
                nextState = STATE_ABOVE_S2;
            end else if (!s[1]) begin
                nextState = STATE_BELOW_S1;
            end else begin
                nextState = STATE_BELOW_S2;
            end
        end
        STATE_ABOVE_S2: begin
            if (!s[2]) begin
                nextState = STATE_BELOW_S2;
            end else begin
                nextState = STATE_ABOVE_S2;
            end
        end
        default: begin
            nextState = STATE_BELOW_S0;
        end
    endcase
end

// Update flow rate outputs
always @(*) begin
    case(currentState)
        STATE_BELOW_S0: begin
            fr0Reg = 1'b1;
            fr1Reg = 1'b1;
            fr2Reg = 1'b1;
            if (previousState < currentState) begin
                dfrReg = 1'b1;
            end else begin
                dfrReg = 1'b0;
            end
        end
        STATE_BELOW_S1: begin
            fr0Reg = 1'b1;
            fr1Reg = 1'b1;
            fr2Reg = 1'b0;
            if (previousState < currentState) begin
                dfrReg = 1'b1;
            end else begin
                dfrReg = 1'b0;
            end
        end
        STATE_BELOW_S2: begin
            fr0Reg = 1'b1;
            fr1Reg = 1'b0;
            fr2Reg = 1'b0;
            if (previousState < currentState) begin
                dfrReg = 1'b1;
            end else begin
                dfrReg = 1'b0;
            end
        end
        STATE_ABOVE_S2: begin
            fr0Reg = 1'b0;
            fr1Reg = 1'b0;
            fr2Reg = 1'b0;
            dfrReg = 1'b0;
        end
        default: begin
            fr0Reg = 1'b1;
            fr1Reg = 1'b1;
            fr2Reg = 1'b1;
            dfrReg = 1'b1;
        end
    endcase
end

// Update state and previous state
always @(posedge clk) begin
    if (reset) begin
        currentState <= STATE_BELOW_S0;
        previousState <= STATE_BELOW_S0;
        fr2Reg <= 1'b1;
        fr1Reg <= 1'b1;
        fr0Reg <= 1'b1;
        dfrReg <= 1'b1;
    end else begin
        currentState <= nextState;
        previousState <= currentState;
    end
end

// Assign outputs
assign fr2 = fr2Reg;
assign fr1 = fr1Reg;
assign fr0 = fr0Reg;
assign dfr = dfrReg;

endmodule