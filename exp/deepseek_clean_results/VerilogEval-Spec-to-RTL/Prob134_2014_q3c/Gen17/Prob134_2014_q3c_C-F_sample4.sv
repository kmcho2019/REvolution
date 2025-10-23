module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state logic - optimized case statement without default
    wire [2:0] next_state;
    always @(*) begin
        case (y)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
        endcase
    end

    // Optimized output logic
    assign Y0 = next_state[0];
    assign z = y[2] | (y[1] & y[0]); // z=1 for states 3'b011 and 3'b100

endmodule