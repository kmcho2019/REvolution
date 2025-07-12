module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Define next state table indexed by present state and input x
    // Since states are 3-bit, create a small ROM with 32 entries (to cover all y)
    // For undefined states, default next_state = 3'b000 and z=0

    reg [2:0] next_state_table[0:31][0:1];
    reg       z_table[0:31];

    integer i;
    initial begin
        // Initialize all entries to default
        for (i = 0; i < 32; i = i + 1) begin
            next_state_table[i][0] = 3'b000;
            next_state_table[i][1] = 3'b000;
            z_table[i] = 1'b0;
        end

        // Define entries for specified states:
        // present y=000 (0): next state x=0:000, x=1:001; z=0
        next_state_table[3'b000][0] = 3'b000;
        next_state_table[3'b000][1] = 3'b001;
        z_table[3'b000] = 1'b0;

        // y=001 (1): next state x=0:001, x=1:100; z=0
        next_state_table[3'b001][0] = 3'b001;
        next_state_table[3'b001][1] = 3'b100;
        z_table[3'b001] = 1'b0;

        // y=010 (2): next state x=0:010, x=1:001; z=0
        next_state_table[3'b010][0] = 3'b010;
        next_state_table[3'b010][1] = 3'b001;
        z_table[3'b010] = 1'b0;

        // y=011 (3): next state x=0:001, x=1:010; z=1
        next_state_table[3'b011][0] = 3'b001;
        next_state_table[3'b011][1] = 3'b010;
        z_table[3'b011] = 1'b1;

        // y=100 (4): next state x=0:011, x=1:100; z=1
        next_state_table[3'b100][0] = 3'b011;
        next_state_table[3'b100][1] = 3'b100;
        z_table[3'b100] = 1'b1;
    end

    wire [2:0] next_state = next_state_table[y][x];
    wire       z_int = z_table[y];

    assign Y0 = next_state[0];
    assign z = z_int;

endmodule