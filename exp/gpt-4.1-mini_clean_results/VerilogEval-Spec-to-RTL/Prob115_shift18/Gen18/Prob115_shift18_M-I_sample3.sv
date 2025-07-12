module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire sign = q[63];

    // Precompute shifted values only if ena is asserted; else pass current q to avoid toggling
    wire [63:0] left1  = ena ? {q[62:0], 1'b0}                : q;
    wire [63:0] left8  = ena ? {q[55:0], 8'b0}                : q;
    wire [63:0] right1 = ena ? {sign, q[63:1]}                : q;
    wire [63:0] right8 = ena ? {{8{sign}}, q[63:8]}           : q;

    // Single 4-way mux for shift selection based on amount
    wire [63:0] shifted;
    assign shifted = (amount == 2'b00) ? left1  :
                     (amount == 2'b01) ? left8  :
                     (amount == 2'b10) ? right1 :
                                         right8 ;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
        else
            q <= q; // Optional; can be omitted
    end

endmodule