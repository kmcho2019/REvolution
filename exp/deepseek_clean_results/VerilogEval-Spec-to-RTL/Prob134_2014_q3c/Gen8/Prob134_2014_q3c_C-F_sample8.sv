module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state logic using efficient case statement
    reg [2:0] next_state;
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
    assign z = (y == 3'b011) | (y == 3'b100);  // Direct comparison for minimal logic

endmodule