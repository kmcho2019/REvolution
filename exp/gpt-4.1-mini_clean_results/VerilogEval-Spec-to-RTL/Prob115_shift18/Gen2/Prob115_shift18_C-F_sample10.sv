module TopModule(
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire [63:0] stage1;
    wire [63:0] shifted;

    // Stage 1: shift by 8 bits if amount[0] == 1, else no shift
    // Direction determined by amount[1]: 0 = left shift, 1 = arithmetic right shift
    assign stage1 = (amount[1] == 1'b0) ? 
                    (amount[0] ? {q[55:0], 8'b0} : q) :                    // left by 8 or no shift
                    (amount[0] ? {{8{q[63]}}, q[63:8]} : q);              // arithmetic right by 8 or no shift

    // Stage 2: shift by 1 bit if needed (amount == 00 or 10), else no shift
    // For left shifts, shift by 1 bit when amount == 00
    // For right shifts, arithmetic shift right by 1 bit when amount == 10
    assign shifted = (amount == 2'b00) ? {stage1[62:0], 1'b0} :         // shift left by 1
                     (amount == 2'b10) ? {stage1[63], stage1[63:1]} :  // arithmetic shift right by 1
                     stage1;                                            // otherwise stage1 result

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule