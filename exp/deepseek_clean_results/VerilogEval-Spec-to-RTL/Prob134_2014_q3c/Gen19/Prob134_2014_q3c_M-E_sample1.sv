module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // LUT implementation (ROM style)
    reg [3:0] fsm_lut [0:15]; // {z, next_state[2:0]}
    
    initial begin
        // Initialize LUT (address = {y[2:0], x})
        // Present state | x=0 next,z | x=1 next,z
        fsm_lut[4'b0000] = 4'b0000; // 000,x=0 → 000,0
        fsm_lut[4'b0001] = 4'b0001; // 000,x=1 → 001,0
        fsm_lut[4'b0010] = 4'b0001; // 001,x=0 → 001,0
        fsm_lut[4'b0011] = 4'b0100; // 001,x=1 → 100,0
        fsm_lut[4'b0100] = 4'b0010; // 010,x=0 → 010,0
        fsm_lut[4'b0101] = 4'b0001; // 010,x=1 → 001,0
        fsm_lut[4'b0110] = 4'b1001; // 011,x=0 → 001,1
        fsm_lut[4'b0111] = 4'b1010; // 011,x=1 → 010,1
        fsm_lut[4'b1000] = 4'b1011; // 100,x=0 → 011,1
        fsm_lut[4'b1001] = 4'b1100; // 100,x=1 → 100,1
        // Default cases (should never occur in proper operation)
        for (int i=10; i<16; i++) fsm_lut[i] = 4'b0000;
    end

    // LUT access
    wire [3:0] lut_out = fsm_lut[{y, x}];
    
    // Output assignments
    assign Y0 = lut_out[0]; // LSB of next state
    assign z = lut_out[3];  // MSB of LUT output

endmodule