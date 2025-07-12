module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000; // A
            z <= 0;
        end else begin
            case (state)
                3'b000: state <= w ? 3'b000 : 3'b001; // A->A or A->B
                3'b001: state <= w ? 3'b011 : 3'b010; // B->D or B->C
                3'b010: state <= w ? 3'b011 : 3'b100; // C->D or C->E
                3'b011: state <= w ? 3'b000 : 3'b101; // D->A or D->F
                3'b100: state <= w ? 3'b011 : 3'b100; // E->D or E->E
                3'b101: state <= w ? 3'b011 : 3'b010; // F->D or F->C
            endcase
            z <= (state == 3'b100) | (state == 3'b101); // E or F
        end
    end

endmodule