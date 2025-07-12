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
            4'b0000: rom_out = 4'b0000; // y=000, x=0 → next=000, z=0
            4'b0001: rom_out = 4'b0010; // y=000, x=1 → next=001, z=0
            4'b0010: rom_out = 4'b0010; // y=001, x=0 → next=001, z=0
            4'b0011: rom_out = 4'b1000; // y=001, x=1 → next=100, z=0
            4'b0100: rom_out = 4'b0100; // y=010, x=0 → next=010, z=0
            4'b0101: rom_out = 4'b0010; // y=010, x=1 → next=001, z=0
            4'b0110: rom_out = 4'b0011; // y=011, x=0 → next=001, z=1
            4'b0111: rom_out = 4'b0101; // y=011, x=1 → next=010, z=1
            4'b1000: rom_out = 4'b0111; // y=100, x=0 → next=011, z=1
            4'b1001: rom_out = 4'b1001; // y=100, x=1 → next=100, z=1
            default: rom_out = 4'b0000; // Default case (shouldn't occur)
        endcase
    end

    assign Y0 = rom_out[0]; // Next state's LSB
    assign z = rom_out[3];  // Output bit

endmodule