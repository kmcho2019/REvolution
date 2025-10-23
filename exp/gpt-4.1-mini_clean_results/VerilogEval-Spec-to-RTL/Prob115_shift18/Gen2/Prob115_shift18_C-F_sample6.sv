module TopModule (
    input        clk,
    input        load,
    input        ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Decode control signals
    wire direction = amount[1];    // 0 = left, 1 = arithmetic right
    wire shift8    = amount[0];    // shift by 8 if set
    wire shift1    = (amount == 2'b00) || (amount == 2'b10); // shift by 1 if amount is 00 or 10

    wire msb = q[63];

    // First stage: 8-bit shift or no 8-bit shift
    wire [63:0] stage1 = (direction == 1'b0) ?           // Left shifts
                         (shift8 ? (q << 8) : q) :
                         // Arithmetic right shifts with sign extension
                         (shift8 ? ({{8{msb}}, q[63:8]}) : q);

    // Second stage: 1-bit shift or no 1-bit shift on stage1
    wire [63:0] stage2 = (direction == 1'b0) ?           // Left shifts
                         (shift1 ? (stage1 << 1) : stage1) :
                         // Arithmetic right shifts with sign extension
                         (shift1 ? ({stage1[63], stage1[63:1]}) : stage1);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= stage2;
        end
        // else hold q
    end

endmodule