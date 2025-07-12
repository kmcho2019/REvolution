module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    reg [63:0] shifted;

    // Shift left by 1 or 8 bits
    wire [63:0] shl_1  = {q[62:0], 1'b0};
    wire [63:0] shl_8  = {q[55:0], 8'b0};

    // Arithmetic shift right by 1 or 8 bits
    wire sign_bit = q[63];
    wire [63:0] shr_1  = {sign_bit, q[63:1]};
    wire [63:0] shr_8  = {{8{sign_bit}}, q[63:8]};

    always @(*) begin
        case (amount)
            2'b00: shifted = shl_1;
            2'b01: shifted = shl_8;
            2'b10: shifted = shr_1;
            2'b11: shifted = shr_8;
            default: shifted = q; // safe default
        endcase
    end

    always @(posedge clk) begin
        if (load) 
            q <= data;
        else if (ena) 
            q <= shifted;
        else 
            q <= q; // hold state
    end

endmodule