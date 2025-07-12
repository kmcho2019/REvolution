module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [2:0] state; // one-hot: state[0]=A, state[1]=g0, state[2]=g1 (g2 is implicit when none of the others are set)

    always @(posedge clk) begin
        if (!resetn) begin
            state <= 3'b001; // Reset to state A
        end else begin
            case (1'b1) // synthesis parallel_case
                state[0]: // State A
                    if (r[0]) state <= 3'b010; // g0
                    else if (r[1]) state <= 3'b100; // g1
                    else if (r[2]) state <= 3'b000; // g2 (implicit)
                    else state <= 3'b001; // stay in A
                state[1]: // g0 state
                    state <= r[0] ? 3'b010 : 3'b001; // stay if r0, else back to A
                state[2]: // g1 state
                    state <= r[1] ? 3'b100 : 3'b001; // stay if r1, else back to A
                default: // g2 state (state == 3'b000)
                    state <= r[2] ? 3'b000 : 3'b001; // stay if r2, else back to A
            endcase
        end
    end

    assign g[0] = state[1];
    assign g[1] = state[2];
    assign g[2] = (state == 3'b000);

endmodule