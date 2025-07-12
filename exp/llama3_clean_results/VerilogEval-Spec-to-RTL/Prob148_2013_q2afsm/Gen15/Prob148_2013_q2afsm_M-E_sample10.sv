module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

parameter IDLE = 3'b000;
parameter GRANT_0 = 3'b001;
parameter GRANT_1 = 3'b010;
parameter GRANT_2 = 3'b011;

reg [2:0] state;

// Idle state module
module IdleState(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output reg [2:0] state
);
    always @(posedge clk) begin
        if (~resetn) state <= IDLE;
        else begin
            case (r)
                3'b001: state <= GRANT_0;
                3'b010: state <= GRANT_1;
                3'b011: state <= GRANT_2;
                default: state <= IDLE;
            endcase
        end
    end
endmodule

// Grant state module
module GrantState(
    input  clk,
    input  resetn,
    input  [2:0] r,
    input  [2:0] currentState,
    output reg [2:0] state
);
    always @(posedge clk) begin
        if (~resetn) state <= IDLE;
        else begin
            case (currentState)
                GRANT_0: if (!r[0]) state <= IDLE; else state <= GRANT_0;
                GRANT_1: if (!r[1]) state <= IDLE; else state <= GRANT_1;
                GRANT_2: if (!r[2]) state <= IDLE; else state <= GRANT_2;
                default: state <= IDLE;
            endcase
        end
    end
endmodule

// Priority encoder module
module PriorityEncoder(
    input  [2:0] r,
    output reg [2:0] grant
);
    always @(*) begin
        case (r)
            3'b001: grant <= 3'b001;
            3'b010: grant <= 3'b010;
            3'b011: grant <= 3'b011;
            default: grant <= 3'b000;
        endcase
    end
endmodule

// Instantiate modules
IdleState idleState(clk, resetn, r, state);
GrantState grantState(clk, resetn, r, state, state);
PriorityEncoder priorityEncoder(r, g);

// Output assignments
assign g[0] = (state == GRANT_0);
assign g[1] = (state == GRANT_1);
assign g[2] = (state == GRANT_2);

endmodule