module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Decode current states from one-hot encoding
wire A = y[0];
wire B = y[1];
wire C = y[2];
wire D = y[3];
wire E = y[4];
wire F = y[5];

// Input complements
wire w0 = ~w;
wire w1 = w;

// Next state logic
assign Y1 = A & w1;                    // B next input: from A on w=1
assign Y3 = (B | C | E | F) & w0;     // D next input: from B,C,E,F on w=0

endmodule