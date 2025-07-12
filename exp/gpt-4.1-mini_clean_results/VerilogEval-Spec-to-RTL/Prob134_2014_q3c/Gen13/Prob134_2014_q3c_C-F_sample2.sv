module TopModule (
    input        clk,    // clock input (unused in combinational FSM logic)
    input        x,
    input  [2:0] y,      // present state
    output reg   Y0,
    output reg   z
);

    reg [2:0] next_state;

    always @(*) begin
        // Determine next state based on present state y and input x
        case (y)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase

        // Output z is high only when present state is 3'b011 or 3'b100
        z = (y == 3'b011) || (y == 3'b100);

        // Y0 is the LSB of the next state
        Y0 = next_state[0];
    end

endmodule