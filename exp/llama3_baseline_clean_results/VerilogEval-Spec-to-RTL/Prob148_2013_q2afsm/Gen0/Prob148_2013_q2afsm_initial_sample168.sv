// Define the states as an enum
`define STATE_A 2'b00
`define STATE_B 2'b01
`define STATE_C 2'b10
`define STATE_D 2'b11

module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define the state variable
reg [1:0] state;
reg [1:0] nextState;

// Continuous assignment for outputs
assign g[0] = (state == `STATE_B);
assign g[1] = (state == `STATE_C);
assign g[2] = 1'b0; // Since state D doesn't set any g[i] to 1

// State table
always @(*) begin
    case (state)
        `STATE_A: begin
            if (r[0] == 1'b1) begin
                nextState = `STATE_B;
            end else if (r[1] == 1'b1) begin
                nextState = `STATE_C;
            end else if (r[2] == 1'b1) begin
                nextState = `STATE_D;
            end else begin
                nextState = `STATE_A;
            end
        end
        `STATE_B: begin
            if (r[0] == 1'b1) begin
                nextState = `STATE_B;
            end else begin
                nextState = `STATE_A;
            end
        end
        `STATE_C: begin
            if (r[1] == 1'b1) begin
                nextState = `STATE_C;
            end else begin
                nextState = `STATE_A;
            end
        end
        `STATE_D: begin
            // Since state D doesn't have a condition to stay in it,
            // it should actually not be included in the state diagram.
            // This is based on the given state diagram description.
            // To fix this, state D should not be reachable from state A.
            // Hence, we don't include state D in the state diagram.
            // The correct implementation is to assign nextState = `STATE_A;
            // when r[0] == 1'b0, r[1] == 1'b0, and r[2] == 1'b0 in state A.
            nextState = `STATE_A;
        end
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        state <= `STATE_A;
    end else begin
        state <= nextState;
    end
end

endmodule