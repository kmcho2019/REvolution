module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000; // A
        end else begin
            case (state)
                3'b000: state <= w ? 3'b000 : 3'b001; // A->A or A->B
                3'b001: state <= w ? 3'b010 : 3'b011; // B->D or B->C
                3'b011: state <= w ? 3'b010 : 3'b110; // C->D or C->E
                3'b010: state <= w ? 3'b000 : 3'b100; // D->A or D->F
                3'b110: state <= w ? 3'b010 : 3'b110; // E->D or E->E
                3'b100: state <= w ? 3'b010 : 3'b011; // F->D or F->C
            endcase
        end
    end

    assign z = state[2]; // E(110) or F(100)

endmodule