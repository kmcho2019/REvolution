module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [2:0] next_state;

    // Next state logic using case statement
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
    assign z = (y == 3'b011) | (y == 3'b100);  // z=1 only for states 3 and 4

endmodule