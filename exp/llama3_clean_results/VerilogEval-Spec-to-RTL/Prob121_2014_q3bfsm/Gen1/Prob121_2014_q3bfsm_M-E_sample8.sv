module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// Lookup table for next state
reg [2:0] next_state_table [5:0];

initial begin
    next_state_table[0] = 3'b000; // 000, x=0
    next_state_table[1] = 3'b001; // 000, x=1
    next_state_table[2] = 3'b001; // 001, x=0
    next_state_table[3] = 3'b100; // 001, x=1
    next_state_table[4] = 3'b010; // 010, x=0
    next_state_table[5] = 3'b001; // 010, x=1
    next_state_table[6] = 3'b001; // 011, x=0
    next_state_table[7] = 3'b010; // 011, x=1
    next_state_table[8] = 3'b011; // 100, x=0
    next_state_table[9] = 3'b100; // 100, x=1
end

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        case (y)
            3'b000: y <= (x == 1'b0)? next_state_table[0] : next_state_table[1];
            3'b001: y <= (x == 1'b0)? next_state_table[2] : next_state_table[3];
            3'b010: y <= (x == 1'b0)? next_state_table[4] : next_state_table[5];
            3'b011: y <= (x == 1'b0)? next_state_table[6] : next_state_table[7];
            3'b100: y <= (x == 1'b0)? next_state_table[8] : next_state_table[9];
            default: y <= 3'b000; // default state
        endcase
    end
end

always @(*) begin
    case (y)
        3'b000: z = 1'b0;
        3'b001: z = 1'b0;
        3'b010: z = 1'b0;
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0; // default output
    endcase
end

endmodule