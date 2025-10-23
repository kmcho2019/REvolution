module StateTransition(
    input in,
    input [0:0] state,
    output reg [0:0] next_state
);

always @(*) begin
    case(state)
        1'b0: begin // State A
            if(in == 1'b0) begin
                next_state = 1'b1; // From A, in=0 -> B
            end else begin
                next_state = 1'b0; // Stay in A
            end
        end
        1'b1: begin // State B
            if(in == 1'b0) begin
                next_state = 1'b0; // From B, in=0 -> A
            end else begin
                next_state = 1'b1; // Stay in B
            end
        end
        default: begin
            next_state = 1'bx;
        end
    endcase
end

endmodule

module OutputLogic(
    input [0:0] state,
    output reg out
);

always @(*) begin
    case(state)
        1'b0: begin // State A
            out = 1'b0;
        end
        1'b1: begin // State B
            out = 1'b1;
        end
        default: begin
            out = 1'bx;
        end
    endcase
end

endmodule

module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] state;

StateTransition state_transition_module(
   .in(in),
   .state(state),
   .next_state(state)
);

OutputLogic output_logic_module(
   .state(state),
   .out(out)
);

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        state <= state; // No change
    end
end

endmodule