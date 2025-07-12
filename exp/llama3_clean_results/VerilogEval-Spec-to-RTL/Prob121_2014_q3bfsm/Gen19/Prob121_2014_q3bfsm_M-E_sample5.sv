module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state (Gray code encoded)
reg [2:0] next_y; // next state (Gray code encoded)
reg clk_en; // clock enable signal

// Next state and output logic using LUT
always @(*) begin
    case ({y, x})
        4'b0000: {next_y, z} = 4'b0000; // S0, x=0 -> S0, z=0
        4'b0001: {next_y, z} = 4'b0010; // S0, x=1 -> S1, z=0
        4'b0010: {next_y, z} = 4'b0010; // S1, x=0 -> S1, z=0
        4'b0011: {next_y, z} = 4'b1000; // S1, x=1 -> S4, z=0
        4'b0100: {next_y, z} = 4'b0100; // S2, x=0 -> S2, z=0
        4'b0101: {next_y, z} = 4'b0010; // S2, x=1 -> S1, z=0
        4'b0110: {next_y, z} = 4'b0010; // S3, x=0 -> S1, z=1
        4'b0111: {next_y, z} = 4'b0100; // S3, x=1 -> S2, z=1
        4'b1000: {next_y, z} = 4'b0110; // S4, x=0 -> S3, z=1
        4'b1001: {next_y, z} = 4'b1000; // S4, x=1 -> S4, z=1
        default: {next_y, z} = 4'b0000;
    endcase
end

// Clock gating logic based on output
always @(*) begin
    if (z == 1'b1) begin
        clk_en = 1'b0; // Disable clock if output is 1
    end else begin
        clk_en = 1'b1;
    end
end

// Use clock enable for state register
always @(posedge clk) begin
    if (clk_en || reset) begin
        if (reset) begin
            y <= 3'b000; // synchronous active high reset
        end else begin
            y <= next_y;
        end
    end
end

endmodule