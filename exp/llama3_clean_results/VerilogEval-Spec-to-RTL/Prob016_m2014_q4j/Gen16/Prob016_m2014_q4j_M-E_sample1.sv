module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    // Define the lookup table for the sum and carry values
    reg [1:0] lut_out [3:0];
    always @(x, y) begin
        lut_out[0] = (x[0] == 1'b1 && y[0] == 1'b1) ? 2'b11 : 
                      (x[0] == 1'b1 || y[0] == 1'b1) ? 2'b01 : 2'b00;
        lut_out[1] = (x[1] == 1'b1 && y[1] == 1'b1) ? 2'b11 : 
                      (x[1] == 1'b1 || y[1] == 1'b1) ? 2'b01 : 2'b00;
        lut_out[2] = (x[2] == 1'b1 && y[2] == 1'b1) ? 2'b11 : 
                      (x[2] == 1'b1 || y[2] == 1'b1) ? 2'b01 : 2'b00;
        lut_out[3] = (x[3] == 1'b1 && y[3] == 1'b1) ? 2'b11 : 
                      (x[3] == 1'b1 || y[3] == 1'b1) ? 2'b01 : 2'b00;
    end

    // Perform the carry-save addition
    reg [3:0] sum_out;
    reg [3:0] carry_out;
    always @(lut_out) begin
        sum_out[0] = lut_out[0][0];
        carry_out[0] = lut_out[0][1];
        sum_out[1] = lut_out[1][0] ^ carry_out[0];
        carry_out[1] = lut_out[1][1] | (lut_out[1][0] & carry_out[0]);
        sum_out[2] = lut_out[2][0] ^ carry_out[1];
        carry_out[2] = lut_out[2][1] | (lut_out[2][0] & carry_out[1]);
        sum_out[3] = lut_out[3][0] ^ carry_out[2];
        carry_out[3] = lut_out[3][1] | (lut_out[3][0] & carry_out[2]);
    end

    // Generate the final sum and overflow
    assign sum[0] = sum_out[0];
    assign sum[1] = sum_out[1];
    assign sum[2] = sum_out[2];
    assign sum[3] = sum_out[3];
    assign sum[4] = carry_out[3];

endmodule