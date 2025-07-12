module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [3:0] next_state_z; // [3] = z, [2:0] = next_state

    always @(*) begin
        case (y)
            3'b000: next_state_z = (x == 1'b0) ? 4'b0_000 : 4'b0_001; // z=0, next_state=000 or 001
            3'b001: next_state_z = (x == 1'b0) ? 4'b0_001 : 4'b0_100; // z=0, next_state=001 or 100
            3'b010: next_state_z = (x == 1'b0) ? 4'b0_010 : 4'b0_001; // z=0, next_state=010 or 001
            3'b011: next_state_z = (x == 1'b0) ? 4'b1_001 : 4'b1_010; // z=1, next_state=001 or 010
            3'b100: next_state_z = (x == 1'b0) ? 4'b1_011 : 4'b1_100; // z=1, next_state=011 or 100
            default: next_state_z = 4'b0_000;
        endcase
    end

    assign z  = next_state_z[3];
    assign Y0 = next_state_z[0];

endmodule