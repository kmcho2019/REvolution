module TopModule (
    input x,
    input y,
    output reg z
);

    // Concatenate inputs to form 2-bit selector
    wire [1:0] sel = {x, y};

    // LUT implementation using case statement
    always @(*) begin
        case(sel)
            2'b00: z = 1'b1;  // x=0, y=0 → z=1
            2'b01: z = 1'b0;  // x=0, y=1 → z=0
            2'b10: z = 1'b0;  // x=1, y=0 → z=0
            2'b11: z = 1'b1;  // x=1, y=1 → z=1
            default: z = 1'b1; // default case (should never occur)
        endcase
    end

endmodule