module StateA(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output reg [2:0] state,
    output reg [2:0] g
);

always @(posedge clk) begin
    if (~resetn) begin
        state <= 3'b000;
        g <= 3'b000;
    end else begin
        case (r)
            3'b001: begin
                state <= 3'b001;
                g <= 3'b001;
            end
            3'b010: begin
                state <= 3'b010;
                g <= 3'b010;
            end
            3'b100: begin
                state <= 3'b011;
                g <= 3'b100;
            end
            default: begin
                state <= 3'b000;
                g <= 3'b000;
            end
        endcase
    end
end

endmodule

module StateB(
    input  clk,
    input  resetn,
    input  [2:0] r,
    input  [2:0] currentState,
    output reg [2:0] nextState,
    output reg [2:0] g
);

always @(posedge clk) begin
    if (~resetn) begin
        nextState <= 3'b000;
        g <= 3'b000;
    end else begin
        case (currentState)
            3'b001: begin
                if (r[0]) begin
                    nextState <= 3'b001;
                    g <= 3'b001;
                end else begin
                    nextState <= 3'b000;
                    g <= 3'b000;
                end
            end
            default: begin
                nextState <= 3'b000;
                g <= 3'b000;
            end
        endcase
    end
end

endmodule

module StateC(
    input  clk,
    input  resetn,
    input  [2:0] r,
    input  [2:0] currentState,
    output reg [2:0] nextState,
    output reg [2:0] g
);

always @(posedge clk) begin
    if (~resetn) begin
        nextState <= 3'b000;
        g <= 3'b000;
    end else begin
        case (currentState)
            3'b010: begin
                if (r[1]) begin
                    nextState <= 3'b010;
                    g <= 3'b010;
                end else begin
                    nextState <= 3'b000;
                    g <= 3'b000;
                end
            end
            default: begin
                nextState <= 3'b000;
                g <= 3'b000;
            end
        endcase
    end
end

endmodule

module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;
reg [2:0] nextState;

StateA stateA(
   .clk(clk),
   .resetn(resetn),
   .r(r),
   .state(state),
   .g(g)
);

StateB stateB(
   .clk(clk),
   .resetn(resetn),
   .r(r),
   .currentState(state),
   .nextState(nextState),
   .g(g)
);

StateC stateC(
   .clk(clk),
   .resetn(resetn),
   .r(r),
   .currentState(state),
   .nextState(nextState),
   .g(g)
);

always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else state <= nextState;
end

endmodule