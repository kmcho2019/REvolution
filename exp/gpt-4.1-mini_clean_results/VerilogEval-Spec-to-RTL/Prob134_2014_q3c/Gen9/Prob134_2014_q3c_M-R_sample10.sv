module TopModule (
    input        clk,   // clock input (not used)
    input        x,
    input  [2:0] y,     // present state
    output reg   Y0,
    output reg   z
);

    reg [2:0] next_state;

    // Combinational logic for next state based on present state and input x
    always @(*) begin
        case (y)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase
    end

    // Combinational logic for output z based on present state
    always @(*) begin
        case (y)
            3'b000, 3'b001, 3'b010: z = 1'b0;
            3'b011, 3'b100:         z = 1'b1;
            default:                z = 1'b0;
        endcase
    end

    // Assign Y0 as the LSB of next state
    always @(*) begin
        Y0 = next_state[0];
    end

endmodule