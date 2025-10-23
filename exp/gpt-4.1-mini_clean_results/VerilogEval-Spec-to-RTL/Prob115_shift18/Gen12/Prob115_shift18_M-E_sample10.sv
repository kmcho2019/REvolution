module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);
    // Direction: 0=left shift, 1=arithmetic right shift
    wire dir = amount[1];
    // Shift magnitude selector: 0=1-bit shift, 1=8-bit shift
    wire mag = amount[0];

    // Stage 1: shift by 1 bit if mag==0, else pass through q unchanged
    wire [63:0] stage1;
    generate
        if (!dir) begin : gen_left_stage1
            // Left shift by 1
            assign stage1 = mag ? q : (q << 1);
        end else begin : gen_right_stage1
            // Arithmetic right shift by 1
            wire msb = q[63];
            wire [63:0] arith_right_1 = {msb, q[63:1]};
            assign stage1 = mag ? q : arith_right_1;
        end
    endgenerate

    // Stage 2: shift by 8 bits if mag==1, else pass stage1 unchanged
    wire [63:0] stage2;
    generate
        if (!dir) begin : gen_left_stage2
            // Left shift by 8
            assign stage2 = mag ? (q << 8) : stage1;
        end else begin : gen_right_stage2
            // Arithmetic right shift by 8
            wire msb = q[63];
            wire [63:0] arith_right_8 = {{8{msb}}, q[63:8]};
            assign stage2 = mag ? arith_right_8 : stage1;
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= stage2;
        end
    end

endmodule