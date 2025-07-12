module TopModule (
    input           clk,
    input           load,
    input           ena,
    input   [1:0]   amount,
    input   [63:0]  data,
    output reg [63:0] q
);

    // Break q and data into 8 bytes for easier manipulation
    wire [7:0] q_bytes [7:0];
    wire [7:0] data_bytes [7:0];
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin
            assign q_bytes[i] = q[i*8 +: 8];
            assign data_bytes[i] = data[i*8 +: 8];
        end
    endgenerate

    // Helper signals
    wire msb = q[63];

    // Shift by 8 bits left: bytes shifted left by 1 position, low byte zero
    wire [7:0] shift8_left_bytes [7:0];
    generate
        for(i=0; i<7; i=i+1) begin
            assign shift8_left_bytes[7-i] = q_bytes[6 - i];
        end
        assign shift8_left_bytes[0] = 8'b0; // lowest byte zero-filled on left shift
    endgenerate

    // Shift by 8 bits right: bytes shifted right by 1 position, high byte sign-extended
    wire [7:0] shift8_right_bytes [7:0];
    generate
        assign shift8_right_bytes[7] = 8'hFF & {8{msb}}; // MSB byte filled with sign bits
        for(i=0; i<7; i=i+1) begin
            assign shift8_right_bytes[i] = q_bytes[i+1];
        end
    endgenerate

    // Shift by 1 bit left: shift each byte left by 1 bit, carry bit from lower byte
    wire [7:0] shift1_left_bytes [7:0];
    wire carry_in [7:0];
    assign carry_in[0] = 1'b0; // no carry in for lowest byte when shifting left
    generate
        for(i=1; i<8; i=i+1) begin
            assign carry_in[i] = q_bytes[i-1][7]; // MSB bit of previous byte as carry_in
        end
    endgenerate
    generate
        for(i=0; i<8; i=i+1) begin
            // shift byte left by 1, insert carry_in LSB
            assign shift1_left_bytes[i] = {q_bytes[i][6:0], 1'b0} | {7'b0, carry_in[i]};
        end
    endgenerate

    // Shift by 1 bit right arithmetic: shift each byte right by 1 bit, carry bit from higher byte, sign-extend MSB byte
    wire [7:0] shift1_right_bytes [7:0];
    wire carry_in_r [8:0];
    assign carry_in_r[8] = msb; // sign bit for filling at MSB side
    generate
        for(i=7; i>0; i=i-1) begin
            assign carry_in_r[i] = q_bytes[i][0]; // LSB bit of current byte as carry to next lower byte
        end
        assign carry_in_r[0] = 1'b0; // no carry for lowest byte's right shift
    endgenerate
    generate
        for(i=0; i<8; i=i+1) begin
            // shift byte right by 1, insert carry_in_r from next higher byte MSB side
            assign shift1_right_bytes[i] = {carry_in_r[i+1], q_bytes[i][7:1]};
        end
    endgenerate

    // Assemble shifted 64-bit values from byte arrays
    function [63:0] bytes_to_64;
        input [7:0] bytes_arr [7:0];
        integer idx;
        reg [63:0] tmp;
        begin
            for(idx=0; idx<8; idx=idx+1) begin
                tmp[idx*8 +: 8] = bytes_arr[idx];
            end
            bytes_to_64 = tmp;
        end
    endfunction

    wire [63:0] shift_left_1  = bytes_to_64(shift1_left_bytes);
    wire [63:0] shift_left_8  = bytes_to_64(shift8_left_bytes);
    wire [63:0] shift_right_1 = bytes_to_64(shift1_right_bytes);
    wire [63:0] shift_right_8 = bytes_to_64(shift8_right_bytes);

    // Select shift amount: 0 = 1 bit, 1 = 8 bits
    wire [63:0] shift_val_amt;
    assign shift_val_amt = (amount[0] == 1'b0) ? shift_left_1 : shift_left_8;

    wire [63:0] shift_val_amt_r;
    assign shift_val_amt_r = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;

    // Select direction: 0 = left, 1 = right
    wire [63:0] shift_val = (amount[1] == 1'b0) ? shift_val_amt : shift_val_amt_r;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_val;
        end
    end

endmodule