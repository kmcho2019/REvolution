module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0; // A = 0
        end else begin
            case (state)
                0: state <= w ? 0 : 1;  // A->A or A->B
                1: state <= w ? 3 : 2;   // B->D or B->C
                2: state <= w ? 3 : 4;   // C->D or C->E
                3: state <= w ? 0 : 5;   // D->A or D->F
                4: state <= w ? 3 : 4;   // E->D or E->E
                5: state <= w ? 3 : 2;   // F->D or F->C
            endcase
        end
    end

    // z=1 for states E (4) and F (5)
    assign z = (state == 4) | (state == 5);

endmodule