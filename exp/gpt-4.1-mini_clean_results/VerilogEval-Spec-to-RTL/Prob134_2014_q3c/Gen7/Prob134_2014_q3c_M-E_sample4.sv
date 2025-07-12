module TopModule (
    input clk,          // clock input (not used internally)
    input x,
    input [2:0] y,      // present state input
    output Y0,
    output z
);

    // Define possible next states for x=0 and x=1 indexed by present state y
    // next_state_x0[y] = next state when x=0 and present state = y
    // next_state_x1[y] = next state when x=1 and present state = y
    wire [2:0] next_state_x0 [0:4];
    wire [2:0] next_state_x1 [0:4];

    assign next_state_x0[0] = 3'b000; // y=000
    assign next_state_x1[0] = 3'b001;

    assign next_state_x0[1] = 3'b001; // y=001
    assign next_state_x1[1] = 3'b100;

    assign next_state_x0[2] = 3'b010; // y=010
    assign next_state_x1[2] = 3'b001;

    assign next_state_x0[3] = 3'b001; // y=011
    assign next_state_x1[3] = 3'b010;

    assign next_state_x0[4] = 3'b011; // y=100
    assign next_state_x1[4] = 3'b100;

    // For y > 100 (5) values 101~111, assign defaults
    wire [2:0] default_state = 3'b000;

    // Select next state based on x and y, with bounds check
    wire [2:0] next_state;
    wire invalid_state = (y > 3'd4);
    wire [2:0] next_state_for_y = invalid_state ? default_state :
        (x ? next_state_x1[y] : next_state_x0[y]);

    assign next_state = next_state_for_y;

    // Output z depends only on present state y, implement as lookup using a small ROM
    // Only valid states 000 to 100; other states default to 0
    reg z_reg;
    always @(*) begin
        case (y)
            3'b000: z_reg = 1'b0;
            3'b001: z_reg = 1'b0;
            3'b010: z_reg = 1'b0;
            3'b011: z_reg = 1'b1;
            3'b100: z_reg = 1'b1;
            default: z_reg = 1'b0;
        endcase
    end

    assign z = z_reg;

    // Output Y0 is LSB of next state
    assign Y0 = next_state[0];

endmodule