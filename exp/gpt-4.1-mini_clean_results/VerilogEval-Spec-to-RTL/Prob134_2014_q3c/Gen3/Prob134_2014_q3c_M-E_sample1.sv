module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [3:0] rom_data; // {z, next_state[2:0]}
    wire [3:0] addr = {y, x};

    always @(*) begin
        case (addr)
            4'b0000: rom_data = 4'b0_000; // y=000, x=0 -> next=000, z=0
            4'b0001: rom_data = 4'b0_001; // y=000, x=1 -> next=001, z=0
            4'b0010: rom_data = 4'b0_001; // y=001, x=0 -> next=001, z=0
            4'b0011: rom_data = 4'b0_100; // y=001, x=1 -> next=100, z=0
            4'b0100: rom_data = 4'b0_010; // y=010, x=0 -> next=010, z=0
            4'b0101: rom_data = 4'b0_001; // y=010, x=1 -> next=001, z=0
            4'b0110: rom_data = 4'b1_001; // y=011, x=0 -> next=001, z=1
            4'b0111: rom_data = 4'b1_010; // y=011, x=1 -> next=010, z=1
            4'b1000: rom_data = 4'b1_011; // y=100, x=0 -> next=011, z=1
            4'b1001: rom_data = 4'b1_100; // y=100, x=1 -> next=100, z=1
            default: rom_data = 4'b0_000; // default safe state
        endcase
    end

    wire [2:0] next_state = rom_data[2:0];
    assign z = rom_data[3];
    assign Y0 = next_state[0];

endmodule