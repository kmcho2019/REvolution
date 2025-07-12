module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output [3:0] out
);

wire [5:0] one_hot_sel;

// Decoder: Convert sel[2:0] to a one-hot 6-bit signal (valid for sel 0 to 5)
assign one_hot_sel = (sel < 3'd6) ? (6'b1 << sel) : 6'b0;

// AND data inputs with one-hot selects (replicated to 4 bits)
wire [3:0] and0 = data0 & {4{one_hot_sel[0]}};
wire [3:0] and1 = data1 & {4{one_hot_sel[1]}};
wire [3:0] and2 = data2 & {4{one_hot_sel[2]}};
wire [3:0] and3 = data3 & {4{one_hot_sel[3]}};
wire [3:0] and4 = data4 & {4{one_hot_sel[4]}};
wire [3:0] and5 = data5 & {4{one_hot_sel[5]}};

// OR all AND results to produce the output
assign out = and0 | and1 | and2 | and3 | and4 | and5;

endmodule