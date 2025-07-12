module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Decode control signals
    wire direction = amount[1];    // 0: left shift, 1: arithmetic right shift
    wire shift8    = amount[0];    // shift by 8 bits enable
    wire shift1    = (amount == 2'b00) || (amount == 2'b10); // shift by 1 bit enable

    // Left shift by 8 bits: concatenate lower 56 bits shifted, zero padded lower bits
    wire [63:0] left_shift8  = {q[55:0], 8'b0};
    // Left shift by 1 bit: concatenate lower 63 bits shifted, zero padded LSB
    wire [63:0] left_shift1  = {q[62:0], 1'b0};

    // Arithmetic right shift by 8 bits: sign extend MSB 8 times and shift right 8
    wire [63:0] right_shift8 = {{8{q[63]}}, q[63:8]};
    // Arithmetic right shift by 1 bit: sign extend MSB once and shift right 1
    wire [63:0] right_shift1 = {q[63], q[63:1]};

    // Stage1: apply 8-bit shift if enabled
    wire [63:0] stage1 = (direction == 1'b0) 
                         ? (shift8 ? left_shift8  : q)
                         : (shift8 ? right_shift8 : q);

    // Stage2: apply 1-bit shift if enabled
    wire [63:0] stage2 = (direction == 1'b0)
                         ? (shift1 ? (stage1 << 1) : stage1) // left_shift1 from stage1
                         : (shift1 ? right_shift1_from(stage1) : stage1);

    // For arithmetic right shift by 1 bit on stage1, define function:
    // But stage1 is already shifted by 8 bits or original q.
    // We need to apply arithmetic right shift by 1 bit on stage1.
    // The sign bit is stage1[63], so:
    function [63:0] right_shift1_from;
        input [63:0] val;
        begin
            right_shift1_from = {val[63], val[63:1]};
        end
    endfunction

    // Actually, Verilog does not allow functions inside module to be called in continuous assignments.
    // We'll use a wire instead to hold right_shift1 applied to stage1:

    wire [63:0] stage1_right_shift1 = {stage1[63], stage1[63:1]};

    // Redefine stage2 accordingly:
    wire [63:0] stage2_mux = (direction == 1'b0)
                            ? (shift1 ? {stage1[62:0], 1'b0} : stage1)
                            : (shift1 ? stage1_right_shift1 : stage1);

    // At posedge clk, load data if load=1, else if ena=1 shift by stage2_mux, else hold
    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= stage2_mux;
        else
            q <= q;
    end

endmodule