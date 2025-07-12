module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire sign = q[63];

    // Shift variants
    wire [63:0] left1  = {q[62:0], 1'b0};
    wire [63:0] left8  = {q[55:0], 8'b0};
    wire [63:0] right1 = {sign, q[63:1]};
    wire [63:0] right8 = {{8{sign}}, q[63:8]};

    // Direct 4-way mux selecting shift variant based on amount
    wire [63:0] shifted = (amount == 2'b00) ? left1  :
                          (amount == 2'b01) ? left8  :
                          (amount == 2'b10) ? right1 :
                                              right8;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
        // Hold implicit if no load or ena
    end

endmodule