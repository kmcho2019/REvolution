module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // 1-bit register to store the current state
reg [0:0] next_state; // 1-bit register to store the next state

// State encoding: A = 0, B = 1

always @(*) begin
    case(state)
        1'b1: begin // State B
            out = 1'b1; // output is 1 in state B
            if(in == 1'b0) begin
                next_state = 1'b0; // transition to state A when in = 0
            end else begin
                next_state = 1'b1; // stay in state B when in = 1
            end
        end
        1'b0: begin // State A
            out = 1'b0; // output is 0 in state A
            if(in == 1'b0) begin
                next_state = 1'b1; // transition to state B when in = 0
            end else begin
                next_state = 1'b0; // stay in state A when in = 1
            end
        end
        default: begin
            out = 1'bx;
            next_state = 1'bx;
        end
    endcase
end

always @(posedge clk) begin
    if(reset == 1'b1) begin
        state <= 1'b1; // reset to state B when reset is high
    end else begin
        state <= next_state;
    end
end

endmodule