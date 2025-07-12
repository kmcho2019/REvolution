module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Combine y and x into a 4-bit index
    wire [3:0] idx = {y, x};

    // ROM-style lookup for next_state[2:0] and output z combined into 4 bits:
    // [3]: z
    // [2:0]: next_state[2:0]
    //
    // Index mapping (y[2:0], x):
    // 0000: y=000, x=0 => next_state=000, z=0  => 4'b0_000
    // 0001: y=000, x=1 => next_state=001, z=0  => 4'b0_001
    // 0010: y=001, x=0 => next_state=001, z=0  => 4'b0_001
    // 0011: y=001, x=1 => next_state=100, z=0  => 4'b0_100
    // 0100: y=010, x=0 => next_state=010, z=0  => 4'b0_010
    // 0101: y=010, x=1 => next_state=001, z=0  => 4'b0_001
    // 0110: y=011, x=0 => next_state=001, z=1  => 4'b1_001
    // 0111: y=011, x=1 => next_state=010, z=1  => 4'b1_010
    // 1000: y=100, x=0 => next_state=011, z=1  => 4'b1_011
    // 1001: y=100, x=1 => next_state=100, z=1  => 4'b1_100
    // 1010-1111: unspecified states => assign 0000 for safety

    reg [3:0] lookup;

    always @(*) begin
        case (idx)
            4'b0000: lookup = 4'b0000;
            4'b0001: lookup = 4'b0001;
            4'b0010: lookup = 4'b0001;
            4'b0011: lookup = 4'b0100;
            4'b0100: lookup = 4'b0010;
            4'b0101: lookup = 4'b0001;
            4'b0110: lookup = 4'b1001;
            4'b0111: lookup = 4'b1010;
            4'b1000: lookup = 4'b1011;
            4'b1001: lookup = 4'b1100;
            default: lookup = 4'b0000; // safe default for unused states
        endcase
    end

    // Extract outputs from lookup
    wire [2:0] next_state = lookup[2:0];
    assign z = lookup[3];
    assign Y0 = next_state[0];

endmodule