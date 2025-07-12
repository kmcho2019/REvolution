module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // ROM-based FSM implementation
    reg [3:0] rom_out; // {next_state[2:0], z}

    always @(*) begin
        case ({y, x})
            4'b0000: rom_out = 4'b0000; // state 000, x=0
            4'b0001: rom_out = 4'b0010; // state 000, x=1
            4'b0010: rom_out = 4'b0010; // state 001, x=0
            4'b0011: rom_out = 4'b1000; // state 001, x=1
            4'b0100: rom_out = 4'b0100; // state 010, x=0
            4'b0101: rom_out = 4'b0010; // state 010, x=1
            4'b0110: rom_out = 4'b0011; // state 011, x=0
            4'b0111: rom_out = 4'b0101; // state 011, x=1
            4'b1000: rom_out = 4'b0111; // state 100, x=0
            4'b1001: rom_out = 4'b1001; // state 100, x=1
            default: rom_out = 4'b0000; // should never occur
        endcase
    end

    assign Y0 = rom_out[1]; // Next state's LSB is at bit 1 (rom_out[2:0] = next_state)
    assign z = rom_out[0];

endmodule