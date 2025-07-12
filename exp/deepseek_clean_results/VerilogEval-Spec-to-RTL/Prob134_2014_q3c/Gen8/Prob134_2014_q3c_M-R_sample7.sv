module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [2:0] next_state;
    reg next_z;

    // Next state logic
    always @(*) begin
        case (y)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
            default: next_state = 3'b000;
        endcase
    end

    // Output logic
    always @(*) begin
        case (y)
            3'b000: next_z = 1'b0;
            3'b001: next_z = 1'b0;
            3'b010: next_z = 1'b0;
            3'b011: next_z = 1'b1;
            3'b100: next_z = 1'b1;
            default: next_z = 1'b0;
        endcase
    end

    assign Y0 = next_state[0];
    assign z = next_z;

endmodule