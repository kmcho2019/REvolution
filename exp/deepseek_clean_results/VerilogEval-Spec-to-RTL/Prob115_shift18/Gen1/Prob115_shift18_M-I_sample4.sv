module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

reg [63:0] next_q;
wire [7:0] sign_fill = {8{q[63]}};  // Pre-calculate sign extension

always @(*) begin
    if (load) begin
        next_q = data;
    end else if (ena) begin
        case (amount)
            2'b00: next_q = {q[62:0], 1'b0};       // Shift left by 1
            2'b01: next_q = {q[55:0], 8'b0};       // Shift left by 8
            2'b10: next_q = {q[63], q[63:1]};       // Shift right by 1
            2'b11: next_q = {sign_fill, q[63:8]};   // Shift right by 8
            default: next_q = q;                    // Safe default
        endcase
    end else begin
        next_q = q;
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule