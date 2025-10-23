module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state computation (parallel bit calculation)
    wire Y2_next = (x & (y == 3'b000)) | 
                   (x & (y == 3'b001)) | 
                   (~x & (y == 3'b100)) | 
                   (x & (y == 3'b100));

    wire Y1_next = (~x & (y == 3'b010)) | 
                   (x & (y == 3'b011)) | 
                   (~x & (y == 3'b100));

    wire Y0_next = (x & (y == 3'b000)) | 
                   (~x & (y == 3'b001)) | 
                   (x & (y == 3'b010)) | 
                   (~x & (y == 3'b011));

    // Y0 is simply the LSB of next state
    assign Y0 = Y0_next;

    // Output z is 1 when state is 011 or 100
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule