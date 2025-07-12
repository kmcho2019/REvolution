module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-compute sign extension pattern for right shifts
wire [7:0] sign_ext = {8{q[63]}};

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        case (amount)
            2'b00: q <= {q[62:0], 1'b0};       // Left shift by 1
            2'b01: q <= {q[55:0], 8'b0};      // Left shift by 8
            2'b10: q <= {q[63], q[63:1]};     // Right arithmetic shift by 1
            2'b11: q <= {sign_ext, q[63:8]};   // Right arithmetic shift by 8
            default: q <= q;                   // Explicit default case
        endcase
    end
end

endmodule