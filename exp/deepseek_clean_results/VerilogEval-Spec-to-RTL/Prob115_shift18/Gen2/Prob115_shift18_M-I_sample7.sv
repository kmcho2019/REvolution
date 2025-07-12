module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-compute all possible shift results in parallel
wire [63:0] shift_left_1  = q << 1;
wire [63:0] shift_left_8  = q << 8;
wire [63:0] shift_right_1 = {q[63], q[63:1]};  // Arithmetic right by 1
wire [63:0] shift_right_8 = {{8{q[63]}}, q[63:8]}; // Arithmetic right by 8

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else if (ena) begin
        case (amount)
            2'b00: q <= shift_left_1;
            2'b01: q <= shift_left_8;
            2'b10: q <= shift_right_1;
            2'b11: q <= shift_right_8;
        endcase
    end
end

endmodule