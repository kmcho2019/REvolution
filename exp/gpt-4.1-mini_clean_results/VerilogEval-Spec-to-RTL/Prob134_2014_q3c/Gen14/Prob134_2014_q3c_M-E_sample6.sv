module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,      // present state input (treated as external state here)
    output reg   Y0,
    output reg   z
);

    reg [2:0] next_state;

    always @(*) begin
        case (y)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase

        // Output z depends on current present state y only
        case (y)
            3'b011,
            3'b100: z = 1'b1;
            default: z = 1'b0;
        endcase

        // Y0 is bit 0 of next_state
        Y0 = next_state[0];
    end

endmodule