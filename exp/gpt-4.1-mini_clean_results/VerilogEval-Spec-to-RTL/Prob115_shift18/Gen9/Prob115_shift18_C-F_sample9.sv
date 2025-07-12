module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Decode shift direction and amount
    // amount encoding:
    // 00: shift left by 1
    // 01: shift left by 8
    // 10: shift right arithmetic by 1
    // 11: shift right arithmetic by 8

    wire shift_left = ~amount[1];   // direction: 1=right, 0=left
    wire shift_by_8 = amount[0];

    // Precompute all shift variants:

    // Left shift by 1 or 8 bits: fill zeros in LSB positions
    wire [63:0] left_shift_1 = {q[62:0], 1'b0};
    wire [63:0] left_shift_8 = {q[55:0], 8'b0};

    // Arithmetic right shift by 1 or 8 bits: fill MSB replicated bits
    wire [63:0] right_shift_1 = {msb, q[63:1]};
    wire [63:0] right_shift_8 = {{8{msb}}, q[63:8]};

    // Select shift amount muxes
    wire [63:0] left_shift = shift_by_8 ? left_shift_8 : left_shift_1;
    wire [63:0] right_shift = shift_by_8 ? right_shift_8 : right_shift_1;

    // Final shift output muxed by direction
    wire [63:0] shifted = shift_left ? left_shift : right_shift;

    // Only shift when ena is high and load is low
    wire do_shift = ena && !load;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (do_shift) begin
            q <= shifted;
        end
        // else retain q
    end

endmodule