module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // State encoding remains binary for compactness
    reg [2:0] state;

    // Combined next state and output (ROM width = 3+1 bits)
    wire [3:0] rom_out;

    // ROM implementation as combinational case statement
    assign rom_out = 
        (state == 3'b000) ? (x ? 4'b0010 : 4'b0000) : // State 000
        (state == 3'b001) ? (x ? 4'b1000 : 4'b0010) : // State 001
        (state == 3'b010) ? (x ? 4'b0010 : 4'b0100) : // State 010
        (state == 3'b011) ? (x ? 4'b0101 : 4'b0011) : // State 011
        (state == 3'b100) ? (x ? 4'b1001 : 4'b0111) : // State 100
        4'b0000; // Default case

    // State transition with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z <= 1'b0;
        end
        else begin
            state <= rom_out[3:1]; // Next state bits
            z <= rom_out[0];       // Output bit
        end
    end

endmodule