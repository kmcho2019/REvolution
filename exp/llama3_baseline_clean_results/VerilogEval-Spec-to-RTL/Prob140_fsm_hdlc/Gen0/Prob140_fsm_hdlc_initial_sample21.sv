module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state;
reg [2:0] nextState;
reg discReg, flagReg, errReg;

always @(*) begin
    case(state)
        3'b000: begin // S0
            if(in) begin
                nextState = 3'b001; // S1
            end else begin
                nextState = 3'b000; // S0
            end
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
        3'b001: begin // S1
            if(in) begin
                nextState = 3'b010; // S2
            end else begin
                nextState = 3'b000; // S0
            end
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
        3'b010: begin // S2
            if(in) begin
                nextState = 3'b011; // S3
            end else begin
                nextState = 3'b000; // S0
            end
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
        3'b011: begin // S3
            if(in) begin
                nextState = 3'b100; // S4
            end else begin
                nextState = 3'b000; // S0
            end
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
        3'b100: begin // S4
            if(in) begin
                nextState = 3'b101; // S5
            end else begin
                nextState = 3'b000; // S0
            end
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
        3'b101: begin // S5
            if(in) begin
                nextState = 3'b110; // S6
            end else begin
                nextState = 3'b000; // S0
            end
            discReg = 1'b1;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
        3'b110: begin // S6
            if(in) begin
                nextState = 3'b111; // S7
            end else begin
                nextState = 3'b000; // S0
            end
            discReg = 1'b0;
            flagReg = 1'b1;
            errReg = 1'b0;
        end
        3'b111: begin // S7
            if(in) begin
                nextState = 3'b111; // S7
            end else begin
                nextState = 3'b000; // S0
            end
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b1;
        end
        default: begin
            nextState = 3'b000;
            discReg = 1'b0;
            flagReg = 1'b0;
            errReg = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 3'b000;
    end else begin
        state <= nextState;
    end
    disc <= discReg;
    flag <= flagReg;
    err <= errReg;
end

endmodule