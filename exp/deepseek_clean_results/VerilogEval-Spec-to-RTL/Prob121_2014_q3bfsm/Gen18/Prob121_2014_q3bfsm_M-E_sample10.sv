module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;
    reg [3:0] rom [0:15]; // 8 states x 2 inputs = 16 entries [next_state:z]
    
    initial begin
        // Initialize ROM: {next_state, z}
        rom[4'h0] = 4'b0000; // state 000, x=0
        rom[4'h1] = 4'b0010; // state 000, x=1
        rom[4'h2] = 4'b0010; // state 001, x=0
        rom[4'h3] = 4'b1000; // state 001, x=1
        rom[4'h4] = 4'b0100; // state 010, x=0
        rom[4'h5] = 4'b0010; // state 010, x=1
        rom[4'h6] = 4'b0011; // state 011, x=0
        rom[4'h7] = 4'b0101; // state 011, x=1
        rom[4'h8] = 4'b0111; // state 100, x=0
        rom[4'h9] = 4'b1001; // state 100, x=1
        // Default cases (unused states)
        rom[4'ha] = 4'b0000;
        rom[4'hb] = 4'b0000;
        rom[4'hc] = 4'b0000;
        rom[4'hd] = 4'b0000;
        rom[4'he] = 4'b0000;
        rom[4'hf] = 4'b0000;
    end

    wire [3:0] rom_out;
    assign rom_out = rom[{state, x}];

    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= rom_out[3:1]; // next state bits
    end

    assign z = rom_out[0]; // output bit

endmodule