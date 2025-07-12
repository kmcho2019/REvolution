module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot encoding: A=000001, B=000010, C=000100, D=001000, E=010000, F=100000
    reg [5:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 6'b000001; // A
        end else begin
            case (1'b1) // synthesis parallel_case
                state[0]: state <= w ? 6'b000001 : 6'b000010; // A->A or A->B
                state[1]: state <= w ? 6'b001000 : 6'b000100;  // B->D or B->C
                state[2]: state <= w ? 6'b001000 : 6'b010000;  // C->D or C->E
                state[3]: state <= w ? 6'b000001 : 6'b100000;  // D->A or D->F
                state[4]: state <= w ? 6'b001000 : 6'b010000;  // E->D or E->E
                state[5]: state <= w ? 6'b001000 : 6'b000100;  // F->D or F->C
            endcase
        end
    end

    assign z = state[4] | state[5]; // E or F

endmodule