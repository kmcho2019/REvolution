module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

// ROM definition for state transitions
reg [4:0] state_rom [0:30];

initial begin
    // Initialize ROM with all possible state transitions
    state_rom[0]  = 5'b00010;
    state_rom[1]  = 5'b00100;
    state_rom[2]  = 5'b01000;
    state_rom[3]  = 5'b10000;
    state_rom[4]  = 5'b00101;
    state_rom[5]  = 5'b01010;
    state_rom[6]  = 5'b10100;
    state_rom[7]  = 5'b01101;
    state_rom[8]  = 5'b11010;
    state_rom[9]  = 5'b10001;
    state_rom[10] = 5'b00111;
    state_rom[11] = 5'b01110;
    state_rom[12] = 5'b11100;
    state_rom[13] = 5'b11101;
    state_rom[14] = 5'b11111;
    state_rom[15] = 5'b11011;
    state_rom[16] = 5'b10011;
    state_rom[17] = 5'b00011;
    state_rom[18] = 5'b00110;
    state_rom[19] = 5'b01100;
    state_rom[20] = 5'b11000;
    state_rom[21] = 5'b10101;
    state_rom[22] = 5'b01111;
    state_rom[23] = 5'b11110;
    state_rom[24] = 5'b11001;
    state_rom[25] = 5'b10111;
    state_rom[26] = 5'b01011;
    state_rom[27] = 5'b10110;
    state_rom[28] = 5'b01001;
    state_rom[29] = 5'b10010;
    state_rom[30] = 5'b00001;
end

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Convert current state to ROM address (subtract 1 since states are 1-31)
        q <= state_rom[q - 1];
    end
end

endmodule