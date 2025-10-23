module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111;

reg [2:0] state, nextState;
reg discReg, flagReg, errReg;

always @(*) begin
    case(state)
        S0: begin
            if(in) begin
                nextState = S1;
                discReg = 0;
                flagReg = 0;
                errReg = 0;
            end else begin
                nextState = S0;
                discReg = 0;
                flagReg = 0;
                errReg = 0;
            end
        end
        S1: begin
            if(in) begin
                nextState = S2;
                discReg = 0;
                flagReg = 0;
                errReg = 0;
            end else begin
                nextState = S0;
                discReg = 0;
                flagReg = 0;
                errReg = 0;
            end
        end
        S2: begin
            if(in) begin
                nextState = S3;
                discReg = 0;
                flagReg = 0;
                errReg = 0;
            end else begin
                nextState = S0;
                discReg = 0;
                flagReg = 0;
                errReg = 0;
            end
        end
        S3: begin
            if(in) begin
                nextState = S4;
                discReg = 0;
                flagReg = 0;
                errReg = 0;
            end else begin
                nextState = S0;
                discReg = 0;
                flagReg = 0;
                errReg = 0;
            end
        end
        S4: begin
            if(in) begin
                nextState = S5;
                discReg = 0;
                flagReg = 0;
                errReg = 0;
            end else begin
                nextState = S0;
                discReg = 0;
                flagReg = 0;
                errReg = 0;
            end
        end
        S5: begin
            if(in) begin
                nextState = S6;
                discReg = 1; // Signal to discard the bit after 5 consecutive 1s
                flagReg = 0;
                errReg = 0;
            end else begin
                nextState = S0;
                discReg = 0;
                flagReg = 1; // Flag the beginning/end of a frame
                errReg = 0;
            end
        end
        S6: begin
            if(in) begin
                nextState = S7;
                discReg = 0;
                flagReg = 0;
                errReg = 1; // Error due to 7 or more consecutive 1s
            end else begin
                nextState = S0;
                discReg = 0;
                flagReg = 1; // Flag the beginning/end of a frame
                errReg = 0;
            end
        end
        S7: begin
            if(in) begin
                nextState = S7;
                discReg = 0;
                flagReg = 0;
                errReg = 1; // Continue signaling error
            end else begin
                nextState = S0;
                discReg = 0;
                flagReg = 0;
                errReg = 0;
            end
        end
        default: begin
            nextState = S0;
            discReg = 0;
            flagReg = 0;
            errReg = 0;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= S0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        state <= nextState;
        disc <= discReg;
        flag <= flagReg;
        err <= errReg;
    end
end

endmodule