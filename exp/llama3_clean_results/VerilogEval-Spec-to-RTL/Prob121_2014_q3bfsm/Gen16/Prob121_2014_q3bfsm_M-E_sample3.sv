module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// Memory to store next state and output information
reg [2:0] state_mem [8]; // 2^3 possible states (including invalid states)
reg [0:0] output_mem [8]; // Output for each state

// Initialize memory contents
initial begin
    state_mem[0] = 3'b000; // State 000, x=0
    state_mem[1] = 3'b001; // State 000, x=1
    state_mem[2] = 3'b001; // State 001, x=0
    state_mem[3] = 3'b100; // State 001, x=1
    state_mem[4] = 3'b010; // State 010, x=0
    state_mem[5] = 3'b001; // State 010, x=1
    state_mem[6] = 3'b001; // State 011, x=0
    state_mem[7] = 3'b010; // State 011, x=1

    output_mem[0] = 1'b0; // Output for state 000
    output_mem[1] = 1'b0; // Output for state 001
    output_mem[2] = 1'b0; // Output for state 001
    output_mem[3] = 1'b1; // Output for state 100
    output_mem[4] = 1'b0; // Output for state 010
    output_mem[5] = 1'b1; // Output for state 001
    output_mem[6] = 1'b1; // Output for state 011
    output_mem[7] = 1'b1; // Output for state 100
end

// Next state logic using memory
always @(*) begin
    case ({y, x})
        4'b0000: next_y = state_mem[0];
        4'b0001: next_y = state_mem[1];
        4'b0010: next_y = state_mem[2];
        4'b0011: next_y = state_mem[3];
        4'b0100: next_y = state_mem[4];
        4'b0101: next_y = state_mem[5];
        4'b0110: next_y = state_mem[6];
        4'b0111: next_y = state_mem[7];
        default: next_y = 3'b000;
    endcase
end

// Output logic using memory
always @(*) begin
    case (y)
        3'b000: z = output_mem[0];
        3'b001: z = output_mem[1];
        3'b010: z = output_mem[4];
        3'b011: z = output_mem[6];
        3'b100: z = output_mem[3];
        default: z = 1'b0;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Synchronous active high reset
    end else begin
        y <= next_y;
    end
end

endmodule