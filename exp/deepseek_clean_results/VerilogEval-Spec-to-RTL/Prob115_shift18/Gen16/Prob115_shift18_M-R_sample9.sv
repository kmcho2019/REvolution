module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-computed sign extension masks
wire [63:0] sign_ext_1 = {64{q[63]}} & 64'hFFFFFFFFFFFFFFFE;
wire [63:0] sign_ext_8 = {64{q[63]}} & 64'hFFFFFFFFFFFFFF00;

// Shift operations
wire [63:0] shift_left_1 = {q[62:0], 1'b0};
wire [63:0] shift_left_8 = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = {q[63], q[63:1]} | sign_ext_1;
wire [63:0] shift_right_8 = {{8{q[63]}}, q[63:8]} | sign_ext_8;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        case (amount)
            2'b00: q <= shift_left_1;
            2'b01: q <= shift_left_8;
            2'b10: q <= shift_right_1;
            2'b11: q <= shift_right_8;
        endcase
    end
end

endmodule