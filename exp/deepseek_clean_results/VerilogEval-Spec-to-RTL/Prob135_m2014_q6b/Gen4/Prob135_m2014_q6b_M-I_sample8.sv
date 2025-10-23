module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    always @(*) begin
        case ({y, w})
            // Transitions where y[1] becomes 1
            4'b0011: next_y1 = 1'b1;  // B -> D
            4'b0101: next_y1 = 1'b1;  // C -> D
            4'b0100: next_y1 = 1'b1;  // C -> E
            4'b0110: next_y1 = 1'b1;  // D -> F
            4'b1001: next_y1 = 1'b1;  // E -> D
            4'b1011: next_y1 = 1'b1;  // F -> D
            
            // Transitions where y[1] stays 1
            4'b1000: next_y1 = 1'b1;  // E -> E
            
            // Transitions where y[1] becomes 0
            4'b0000: next_y1 = 1'b0;  // A -> B
            4'b0010: next_y1 = 1'b0;  // B -> C
            4'b0111: next_y1 = 1'b0;  // D -> A
            4'b1010: next_y1 = 1'b0;  // F -> C
            
            // Default case (A->A and any unspecified transitions)
            default: next_y1 = y[1];  // Maintain current value
        endcase
    end

endmodule