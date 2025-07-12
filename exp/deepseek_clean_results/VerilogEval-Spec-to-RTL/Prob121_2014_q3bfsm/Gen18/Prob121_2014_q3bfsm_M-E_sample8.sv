module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;
    wire [3:0] rom_out; // {next_state[2:0], z}

    // ROM implementation
    reg [3:0] rom [0:15];
    initial begin
        // Address format: {state[2:0], x}
        rom[4'b0000] = 4'b0000; // state=000, x=0 -> next=000, z=0
        rom[4'b0001] = 4'b0010; // state=000, x=1 -> next=001, z=0
        rom[4'b0010] = 4'b0010; // state=001, x=0 -> next=001, z=0
        rom[4'b0011] = 4'b1000; // state=001, x=1 -> next=100, z=0
        rom[4'b0100] = 4'b0100; // state=010, x=0 -> next=010, z=0
        rom[4'b0101] = 4'b0010; // state=010, x=1 -> next=001, z=0
        rom[4'b0110] = 4'b0011; // state=011, x=0 -> next=001, z=1
        rom[4'b0111] = 4'b0101; // state=011, x=1 -> next=010, z=1
        rom[4'b1000] = 4'b0111; // state=100, x=0 -> next=011, z=1
        rom[4'b1001] = 4'b1001; // state=100, x=1 -> next=100, z=1
        // Default cases (shouldn't occur)
        rom[4'b1010] = 4'b0000;
        rom[4'b1011] = 4'b0000;
        rom[4'b1100] = 4'b0000;
        rom[4'b1101] = 4'b0000;
        rom[4'b1110] = 4'b0000;
        rom[4'b1111] = 4'b0000;
    end

    assign rom_out = rom[{state, x}];

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z <= 1'b0;
        end
        else begin
            state <= rom_out[3:1];
            z <= rom_out[0];
        end
    end

endmodule