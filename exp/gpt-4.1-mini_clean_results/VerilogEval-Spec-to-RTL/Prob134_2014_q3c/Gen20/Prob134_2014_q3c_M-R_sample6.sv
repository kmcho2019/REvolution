module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output reg   Y0,
    output       z
);

    reg [2:0] next_state;

    // Combinational logic for next state using case statements
    always @(*) begin
        case (y)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
            default: next_state = 3'b000; // default safe state
        endcase
    end

    // Output Y0 = LSB of next state
    always @(*) begin
        Y0 = next_state[0];
    end

    // Output z combinational: 1 when present state is 011 or 100
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule