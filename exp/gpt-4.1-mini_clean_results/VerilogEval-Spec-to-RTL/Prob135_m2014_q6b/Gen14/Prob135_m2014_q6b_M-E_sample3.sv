module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg next_y1;

    // Enumerate transitions based on the FSM and output next y[1].
    always @(*) begin
        case ({y, w})
            // State A (000)
            4'b0000: next_y1 = 1'b0; // A->B (001), y1=0
            4'b0001: next_y1 = 1'b0; // A->A (000), y1=0

            // State B (001)
            4'b0010: next_y1 = 1'b0; // B->C (010), y1=0
            4'b0011: next_y1 = 1'b1; // B->D (011), y1=1

            // State C (010)
            4'b0100: next_y1 = 1'b0; // C->E (100), y1=0
            4'b0101: next_y1 = 1'b1; // C->D (011), y1=1

            // State D (011)
            4'b0110: next_y1 = 1'b1; // D->F (101), y1=1
            4'b0111: next_y1 = 1'b0; // D->A (000), y1=0

            // State E (100)
            4'b1000: next_y1 = 1'b0; // E->E (100), y1=0
            4'b1001: next_y1 = 1'b1; // E->D (011), y1=1

            // State F (101)
            4'b1010: next_y1 = 1'b0; // F->C (010), y1=0
            4'b1011: next_y1 = 1'b1; // F->D (011), y1=1

            // For all other cases (states F+, unused states)
            default: next_y1 = y[1]; 
        endcase
    end

    assign Y1 = y[1];

endmodule