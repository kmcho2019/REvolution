module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot state encoding with two flip-flops
reg state_A;
reg state_B;

// Next state signals
reg next_state_A;
reg next_state_B;

// Output logic (Mealy)
assign z = (state_A & x) | (state_B & ~x);

// Next state logic combinational
always @(*) begin
    case ({state_A, state_B})
        2'b10: begin // state A
            if (x == 1'b0) begin
                next_state_A = 1'b1;
                next_state_B = 1'b0;
            end else begin
                next_state_A = 1'b0;
                next_state_B = 1'b1;
            end
        end
        2'b01: begin // state B
            // stay in B regardless of x
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end
        default: begin
            // Invalid state, reset to A
            next_state_A = 1'b1;
            next_state_B = 1'b0;
        end
    endcase
end

// State registers with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1; // reset into state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule