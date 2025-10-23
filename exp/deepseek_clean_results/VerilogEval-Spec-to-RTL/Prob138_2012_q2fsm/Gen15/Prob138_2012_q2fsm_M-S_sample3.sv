module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) state <= 3'b000; // A
        else case (state)
            3'b000: state <= w ? 3'b001 : 3'b000; // A->B or A->A
            3'b001: state <= w ? 3'b011 : 3'b010; // B->C or B->D
            3'b011: state <= w ? 3'b111 : 3'b010; // C->E or C->D
            3'b010: state <= w ? 3'b110 : 3'b000;  // D->F or D->A
            3'b111: state <= w ? 3'b111 : 3'b010;  // E->E or E->D
            3'b110: state <= w ? 3'b011 : 3'b010;  // F->C or F->D
            default: state <= 3'b000;
        endcase
    end

    assign z = state[2]; // E and F have MSB=1

endmodule