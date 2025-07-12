module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // Current state
reg [2:0] nextState; // Next state
reg discReg; // disc output register
reg flagReg; // flag output register
reg errReg; // err output register

// Define states
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;
localparam S6 = 3'b110;
localparam S_ERR = 3'b111;

always @(*) begin
    case (state)
        S0: begin
            if (in) nextState = S1;
            else nextState = S0;
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
        S1: begin
            if (in) nextState = S2;
            else nextState = S0;
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
        S2: begin
            if (in) nextState = S3;
            else nextState = S0;
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
        S3: begin
            if (in) nextState = S4;
            else nextState = S0;
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
        S4: begin
            if (in) nextState = S5;
            else nextState = S0;
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
        S5: begin
            if (in) nextState = S6;
            else nextState = S0;
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
        S6: begin
            if (in) begin
                nextState = S_ERR;
                discReg = 1'b1; // Signal to discard the bit
            end
            else begin
                nextState = S0;
                flagReg = 1'b1; // Flag the beginning/end of a frame
            end
            errReg = 1'b0;
        end
        S_ERR: begin
            if (!in) nextState = S0;
            else nextState = S_ERR;
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b1; // Signal an error
        end
        default: begin
            nextState = S0;
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end
    else begin
        state <= nextState;
        disc <= discReg;
        flag <= flagReg;
        err <= errReg;
    end
end

endmodule