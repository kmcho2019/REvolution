module TopModule (
    input        clk,
    input        reset,
    input        slowena,
    output reg [3:0] q
);

reg [9:0] onehot; // One-hot state: bit0 = count 0, bit9 = count 9

// One-hot next state logic: rotate left with wrap-around
wire [9:0] next_onehot = (onehot << 1) | (onehot[9]);

// Decode onehot to binary count (q)
integer i;
always @(*) begin
    q = 4'd0;
    for (i = 0; i < 10; i = i + 1) begin
        if (onehot[i])
            q = i[3:0];
    end
end

// Sequential logic: synchronous reset and enable-controlled shift
always @(posedge clk) begin
    if (reset)
        onehot <= 10'b0000000001; // count 0
    else if (slowena)
        onehot <= next_onehot;
    else
        onehot <= onehot; // hold state if slowena is low
end

endmodule