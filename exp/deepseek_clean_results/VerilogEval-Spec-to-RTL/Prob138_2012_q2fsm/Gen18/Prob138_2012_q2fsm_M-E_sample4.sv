module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] counter;
    wire [2:0] next_counter;

    // State encoding:
    // 000: A
    // 001: B
    // 010: D
    // 011: C
    // 100: F
    // 101: E (note: E and F swapped positions for simpler logic)

    // Next state logic
    assign next_counter = 
        (counter == 3'b000) ? (w ? 3'b001 : 3'b000) : // A->B or A->A
        (counter == 3'b001) ? (w ? 3'b011 : 3'b010) : // B->C or B->D
        (counter == 3'b011) ? (w ? 3'b101 : 3'b010) : // C->E or C->D
        (counter == 3'b010) ? (w ? 3'b100 : 3'b000) :  // D->F or D->A
        (counter == 3'b101) ? (w ? 3'b101 : 3'b010) :  // E->E or E->D
        (counter == 3'b100) ? (w ? 3'b011 : 3'b010) :  // F->C or F->D
        3'b000; // default to A

    // State register
    always @(posedge clk) begin
        if (reset) counter <= 3'b000;
        else counter <= next_counter;
    end

    // Output logic (E=101, F=100)
    assign z = (counter == 3'b101) || (counter == 3'b100);

endmodule