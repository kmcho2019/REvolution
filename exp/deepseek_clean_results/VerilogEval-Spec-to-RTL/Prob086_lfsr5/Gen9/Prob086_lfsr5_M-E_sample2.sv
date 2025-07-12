module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

// ROM containing next state for each current state (address)
reg [4:0] lfsr_rom [0:31];

initial begin
    // Initialize ROM with next state transitions
    // Address is current state, data is next state
    lfsr_rom[5'b00000] = 5'b00000; // Invalid state (never reached)
    lfsr_rom[5'b00001] = 5'b10000;
    lfsr_rom[5'b00010] = 5'b01000;
    lfsr_rom[5'b00011] = 5'b10100;
    lfsr_rom[5'b00100] = 5'b01010;
    lfsr_rom[5'b00101] = 5'b10101;
    lfsr_rom[5'b00110] = 5'b11010;
    lfsr_rom[5'b00111] = 5'b11101;
    lfsr_rom[5'b01000] = 5'b11100;
    lfsr_rom[5'b01001] = 5'b01110;
    lfsr_rom[5'b01010] = 5'b00111;
    lfsr_rom[5'b01011] = 5'b10011;
    lfsr_rom[5'b01100] = 5'b11001;
    lfsr_rom[5'b01101] = 5'b11100;
    lfsr_rom[5'b01110] = 5'b01110;
    lfsr_rom[5'b01111] = 5'b00111;
    lfsr_rom[5'b10000] = 5'b10011;
    lfsr_rom[5'b10001] = 5'b11001;
    lfsr_rom[5'b10010] = 5'b11100;
    lfsr_rom[5'b10011] = 5'b01110;
    lfsr_rom[5'b10100] = 5'b00111;
    lfsr_rom[5'b10101] = 5'b10011;
    lfsr_rom[5'b10110] = 5'b11001;
    lfsr_rom[5'b10111] = 5'b11100;
    lfsr_rom[5'b11000] = 5'b01110;
    lfsr_rom[5'b11001] = 5'b00111;
    lfsr_rom[5'b11010] = 5'b10011;
    lfsr_rom[5'b11011] = 5'b11001;
    lfsr_rom[5'b11100] = 5'b11100;
    lfsr_rom[5'b11101] = 5'b01110;
    lfsr_rom[5'b11110] = 5'b00111;
    lfsr_rom[5'b11111] = 5'b10011;
end

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= lfsr_rom[q];
    end
end

endmodule