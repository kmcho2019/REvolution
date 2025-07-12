module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Combine present state and input to a 4-bit index:
    // 3 bits for y + 1 bit for x
    wire [3:0] idx = {y, x};

    // Next state lookup table: index -> next state (3 bits)
    // Index mapping:
    // idx = {y[2], y[1], y[0], x}
    // Values from FSM table:
    // y=000 (0): x=0->000, x=1->001
    // y=001 (1): x=0->001, x=1->100
    // y=010 (2): x=0->010, x=1->001
    // y=011 (3): x=0->001, x=1->010
    // y=100 (4): x=0->011, x=1->100
    // Other states (5-7) not defined, default to 000

    reg [2:0] next_state;
    always @(*) begin
        case (idx)
            4'b0000: next_state = 3'b000; // y=000,x=0
            4'b0001: next_state = 3'b001; // y=000,x=1
            4'b0010: next_state = 3'b001; // y=001,x=0
            4'b0011: next_state = 3'b100; // y=001,x=1
            4'b0100: next_state = 3'b010; // y=010,x=0
            4'b0101: next_state = 3'b001; // y=010,x=1
            4'b0110: next_state = 3'b001; // y=011,x=0
            4'b0111: next_state = 3'b010; // y=011,x=1
            4'b1000: next_state = 3'b011; // y=100,x=0
            4'b1001: next_state = 3'b100; // y=100,x=1
            default: next_state = 3'b000; // default safe state
        endcase
    end

    // Output z logic minimized:
    // z = (~y[2]&y[1]&y[0]) | (y[2]&~y[1]&~y[0])
    assign z = (~y[2] & y[1] & y[0]) | (y[2] & ~y[1] & ~y[0]);

    // Y0 is the LSB of next_state
    assign Y0 = next_state[0];

endmodule