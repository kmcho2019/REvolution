module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;
reg [2:0] nextState;

// Next-state logic module
module NextState(
    input  [2:0] currentState,
    input  [2:0] r,
    output [2:0] nextState
);
    always @(*) begin
        case (currentState)
            3'b000: 
                if (r[0]) nextState = 3'b001;
                else if (r[1]) nextState = 3'b010;
                else if (r[2]) nextState = 3'b011;
                else nextState = 3'b000;
            3'b001: if (!r[0]) nextState = 3'b000; else nextState = 3'b001;
            3'b010: if (!r[1]) nextState = 3'b000; else nextState = 3'b010;
            3'b011: if (!r[2]) nextState = 3'b000; else nextState = 3'b011;
            default: nextState = 3'b000;
        endcase
    end
endmodule

// Output logic module
module OutputLogic(
    input  [2:0] state,
    output [2:0] g
);
    assign g[0] = (state == 3'b001);
    assign g[1] = (state == 3'b010);
    assign g[2] = (state == 3'b011);
endmodule

// Instantiate next-state logic module
NextState next_state_module(
    .currentState(state),
    .r(r),
    .nextState(nextState)
);

// Instantiate output logic module
OutputLogic output_logic_module(
    .state(state),
    .g(g)
);

// State flip-flops
always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else state <= nextState;
end

endmodule