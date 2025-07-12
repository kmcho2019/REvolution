module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Decode direction and amount signals
    wire dir = amount[1];    // 0: left shift, 1: right shift
    wire amt = amount[0];    // 0: shift by 1, 1: shift by 8

    wire [63:0] shifted;

    // Generate shifted output based on direction first
    wire [63:0] left_shifted;
    wire [63:0] right_shifted;

    // Shift left by 1 and 8 using concatenation
    assign left_shifted = (amt == 1'b0) ? {q[62:0], 1'b0} : {q[55:0], 8'b0};

    // Arithmetic shift right by 1 and 8 using concatenation and sign extension
    assign right_shifted = (amt == 1'b0) ? {msb, q[63:1]} : {{8{msb}}, q[63:8]};

    // Select shifted output based on direction bit
    assign shifted = (dir == 1'b0) ? left_shifted : right_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule