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
reg discReg;
reg flagReg;
reg errReg;

// State encoding
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;
localparam S6 = 3'b110;
localparam S7 = 3'b111;

always @(*) begin
    case (state)
        S0: begin
            if (in) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
        end
        S1: begin
            if (in) begin
                nextState = S2;
            end else begin
                nextState = S0;
            end
        end
        S2: begin
            if (in) begin
                nextState = S3;
            end else begin
                nextState = S0;
            end
        end
        S3: begin
            if (in) begin
                nextState = S4;
            end else begin
                nextState = S0;
            end
        end
        S4: begin
            if (in) begin
                nextState = S5;
            end else begin
                nextState = S0;
            end
        end
        S5: begin
            if (in) begin
                nextState = S6;
                flagReg = 1'b1;
            end else begin
                nextState = S0;
            end
        end
        S6: begin
            if (in) begin
                nextState = S7;
                errReg = 1'b1;
            end else begin
                nextState = S0;
                discReg = 1'b1;
            end
        end
        S7: begin
            if (in) begin
                nextState = S7;
                errReg = 1'b1;
            end else begin
                nextState = S0;
            end
        end
        default: begin
            nextState = S0;
        end
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
        disc <= discReg;
        flag <= flagReg;
        err <= errReg;
        discReg <= 1'b0;
        flagReg <= 1'b0;
        errReg <= 1'b0;
    end
end

endmodule