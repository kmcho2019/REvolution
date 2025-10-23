module TopModule (
    input        clk,
    input        load,
    input        ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Stage 1: 8-bit shift or hold (combinational)
    wire [63:0] shift8 = (amount == 2'b01) ? (q << 8) :
                         (amount == 2'b11) ? {{8{msb}}, q[63:8]} :
                         q;

    // Stage 2: 1-bit shift or hold (combinational)
    wire [63:0] shift1 = (amount == 2'b00) ? (shift8 << 1) :
                         (amount == 2'b10) ? {shift8[63], shift8[63:1]} :
                         shift8;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift1;
        end
    end

endmodule