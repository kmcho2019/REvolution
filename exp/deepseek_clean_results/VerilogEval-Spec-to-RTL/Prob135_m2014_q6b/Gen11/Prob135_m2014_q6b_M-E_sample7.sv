module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using truth-table approach
    reg next_y1;
    always @(*) begin
        // Concatenate state and input for easy matching
        case ({y, w})
            // State A (000) transitions
            4'b0000: next_y1 = 1'b0;  // A -> B (001)
            4'b0001: next_y1 = 1'b0;  // A -> A (000)
            
            // State B (001) transitions
            4'b0010: next_y1 = 1'b0;  // B -> C (010)
            4'b0011: next_y1 = 1'b1;  // B -> D (011)
            
            // State C (010) transitions
            4'b0100: next_y1 = 1'b0;  // C -> E (100)
            4'b0101: next_y1 = 1'b1;  // C -> D (011)
            
            // State D (011) transitions
            4'b0110: next_y1 = 1'b0;  // D -> F (101)
            4'b0111: next_y1 = 1'b0;  // D -> A (000)
            
            // State E (100) transitions
            4'b1000: next_y1 = 1'b0;  // E -> E (100)
            4'b1001: next_y1 = 1'b1;  // E -> D (011)
            
            // State F (101) transitions
            4'b1010: next_y1 = 1'b0;  // F -> C (010)
            4'b1011: next_y1 = 1'b1;  // F -> D (011)
            
            default: next_y1 = 1'b0;  // Should never occur with 3-bit y
        endcase
    end

endmodule