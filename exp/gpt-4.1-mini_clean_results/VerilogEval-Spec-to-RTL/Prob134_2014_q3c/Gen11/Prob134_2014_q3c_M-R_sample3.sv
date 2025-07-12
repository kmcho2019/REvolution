module TopModule (
    input        clk,   // clock input (not used)
    input        x,
    input  [2:0] y,     // present state
    output       Y0,
    output       z
);

    reg [2:0] next_state;
    reg       out_z;

    // Combinational block for next state logic
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

    // Combinational block for output logic
    always @(*) begin
        case (y)
            3'b011, 3'b100: out_z = 1'b1;
            default:        out_z = 1'b0;
        endcase
    end

    // Assign outputs
    assign Y0 = next_state[0];
    assign z  = out_z;

endmodule