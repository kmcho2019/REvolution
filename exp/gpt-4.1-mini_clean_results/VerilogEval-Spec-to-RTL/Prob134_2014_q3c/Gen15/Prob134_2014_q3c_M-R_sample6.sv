module TopModule (
    input        clk,   // clock input (not used)
    input        x,
    input  [2:0] y,     // present state
    output reg   Y0,
    output reg   z
);

    reg [2:0] next_state;

    // Compute next state combinationally
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

    // Compute output z combinationally based on present state
    always @(*) begin
        case (y)
            3'b000, 3'b001, 3'b010: z = 1'b0;
            3'b011, 3'b100:         z = 1'b1;
            default:                z = 1'b0;
        endcase
    end

    // Assign output Y0 from next_state bit 0 combinationally
    always @(*) begin
        Y0 = next_state[0];
    end

endmodule