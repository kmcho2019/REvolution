module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // LUT format: {next_Y0, z}
    reg [1:0] fsm_lut [0:15];  // 8 states x 2 input values

    // Initialize LUT (readable format)
    initial begin
        // y=000
        fsm_lut[0] = 2'b00;  // x=0: next=000 (Y0=0), z=0
        fsm_lut[1] = 2'b10;  // x=1: next=001 (Y0=1), z=0
        // y=001
        fsm_lut[2] = 2'b10;  // x=0: next=001 (Y0=1), z=0
        fsm_lut[3] = 2'b01;  // x=1: next=100 (Y0=0), z=1
        // y=010
        fsm_lut[4] = 2'b00;  // x=0: next=010 (Y0=0), z=0
        fsm_lut[5] = 2'b10;  // x=1: next=001 (Y0=1), z=0
        // y=011
        fsm_lut[6] = 2'b11;  // x=0: next=001 (Y0=1), z=1
        fsm_lut[7] = 2'b01;  // x=1: next=010 (Y0=0), z=1
        // y=100
        fsm_lut[8] = 2'b11;  // x=0: next=011 (Y0=1), z=1
        fsm_lut[9] = 2'b01;  // x=1: next=100 (Y0=0), z=1
        // Unused states (y=101-111)
        fsm_lut[10] = 2'b00;
        fsm_lut[11] = 2'b00;
        fsm_lut[12] = 2'b00;
        fsm_lut[13] = 2'b00;
        fsm_lut[14] = 2'b00;
        fsm_lut[15] = 2'b00;
    end

    // Index calculation: {y, x}
    wire [3:0] lut_index = {y, x};
    
    // Output assignments
    assign Y0 = fsm_lut[lut_index][1];
    assign z = fsm_lut[lut_index][0];

endmodule