module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define the state encoding
enum logic [2:0] {
    S000 = 3'b000,
    S001 = 3'b001,
    S010 = 3'b010,
    S011 = 3'b011,
    S100 = 3'b100
} state, next_state;

// Define the FSMs
module FSM0(
    input x,
    input [2:0] state,
    output reg [2:0] next_state,
    output reg z
);
    always @(*) begin
        case (state)
            S000: begin
                next_state = x? S001 : S000;
                z = 1'b0;
            end
            S001: begin
                next_state = x? S100 : S001;
                z = 1'b0;
            end
            default: begin
                next_state = S000;
                z = 1'b0;
            end
        endcase
    end
endmodule

module FSM1(
    input x,
    input [2:0] state,
    output reg [2:0] next_state,
    output reg z
);
    always @(*) begin
        case (state)
            S010: begin
                next_state = x? S001 : S010;
                z = 1'b0;
            end
            S011: begin
                next_state = x? S010 : S001;
                z = 1'b1;
            end
            default: begin
                next_state = S010;
                z = 1'b0;
            end
        endcase
    end
endmodule

module FSM2(
    input x,
    input [2:0] state,
    output reg [2:0] next_state,
    output reg z
);
    always @(*) begin
        case (state)
            S100: begin
                next_state = x? S100 : S011;
                z = 1'b1;
            end
            default: begin
                next_state = S100;
                z = 1'b0;
            end
        endcase
    end
endmodule

// Instantiate the FSMs
FSM0 fsm0(
   .x(x),
   .state(state),
   .next_state(next_state),
   .z(z)
);

FSM1 fsm1(
   .x(x),
   .state(state),
   .next_state(next_state),
   .z(z)
);

FSM2 fsm2(
   .x(x),
   .state(state),
   .next_state(next_state),
   .z(z)
);

// Clock gating
reg clock_gated;
always @(*) begin
    case (state)
        S000, S001: clock_gated = 1'b1;
        S010, S011: clock_gated = x? 1'b1 : 1'b0;
        S100: clock_gated = 1'b1;
        default: clock_gated = 1'b0;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= S000;
    end else if (clock_gated) begin
        state <= next_state;
    end
end

endmodule