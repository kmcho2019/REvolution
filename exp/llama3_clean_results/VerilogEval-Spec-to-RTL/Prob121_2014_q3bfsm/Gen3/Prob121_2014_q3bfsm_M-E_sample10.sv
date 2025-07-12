module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state
reg output_z; // Output z

// Lookup table for next state and output
always @(*) begin
    case ({y, x})
        5'b000_0: {next_y, output_z} = 3'b000 << 3 | 1'b0;
        5'b000_1: {next_y, output_z} = 3'b001 << 3 | 1'b0;
        5'b001_0: {next_y, output_z} = 3'b001 << 3 | 1'b0;
        5'b001_1: {next_y, output_z} = 3'b100 << 3 | 1'b0;
        5'b010_0: {next_y, output_z} = 3'b010 << 3 | 1'b0;
        5'b010_1: {next_y, output_z} = 3'b001 << 3 | 1'b0;
        5'b011_0: {next_y, output_z} = 3'b001 << 3 | 1'b1;
        5'b011_1: {next_y, output_z} = 3'b010 << 3 | 1'b1;
        5'b100_0: {next_y, output_z} = 3'b011 << 3 | 1'b1;
        5'b100_1: {next_y, output_z} = 3'b100 << 3 | 1'b1;
        default: {next_y, output_z} = 3'b000 << 3 | 1'b0;
    endcase
end

// Update state and output on clock edge
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
        z <= 1'b0;
    end else begin
        y <= next_y;
        z <= output_z;
    end
end

endmodule