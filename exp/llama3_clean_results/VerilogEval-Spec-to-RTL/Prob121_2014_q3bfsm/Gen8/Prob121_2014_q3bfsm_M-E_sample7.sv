module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

always @(*) begin
    case ({y, x}) // Concatenate current state and input
        5'b00000: {next_y, z} = 5'b00000; // State 000, x=0
        5'b00001: {next_y, z} = 5'b00100; // State 000, x=1
        5'b00100: {next_y, z} = 5'b00100; // State 001, x=0
        5'b00101: {next_y, z} = 5'b10000; // State 001, x=1
        5'b01000: {next_y, z} = 5'b01000; // State 010, x=0
        5'b01001: {next_y, z} = 5'b00100; // State 010, x=1
        5'b01100: {next_y, z} = 5'b00101; // State 011, x=0
        5'b01101: {next_y, z} = 5'b01001; // State 011, x=1
        5'b10000: {next_y, z} = 5'b01101; // State 100, x=0
        5'b10001: {next_y, z} = 5'b10000; // State 100, x=1
        default: {next_y, z} = 5'b00000; // Default case
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Synchronous active high reset
    end else begin
        y <= next_y; // Update current state
    end
end

endmodule