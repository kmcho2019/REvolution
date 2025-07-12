module TopModule (
    input clk,        // clock input (not used internally here)
    input x,
    input [2:0] y,    // present state input
    output Y0,
    output reg z
);

    reg [2:0] next_state;

    always @(*) begin
        // Determine next state based on present state y and input x
        case (y)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
            default: next_state = 3'b000; // default fallback for invalid present state
        endcase

        // Output z depends only on present state y
        case (y)
            3'b000: z = 1'b0;
            3'b001: z = 1'b0;
            3'b010: z = 1'b0;
            3'b011: z = 1'b1;
            3'b100: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

    // Y0 is LSB of next_state
    assign Y0 = next_state[0];

endmodule