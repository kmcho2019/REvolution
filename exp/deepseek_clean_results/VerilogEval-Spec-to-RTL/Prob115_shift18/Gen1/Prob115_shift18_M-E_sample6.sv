module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

wire [63:0] shift_left_1 = {q[62:0], 1'b0};
wire [63:0] shift_left_8 = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = {q[63], q[63:1]};
wire [63:0] shift_right_8 = {{8{q[63]}}, q[63:8]};

wire [63:0] next_q;

assign next_q = (amount == 2'b00) ? shift_left_1 :
               (amount == 2'b01) ? shift_left_8 :
               (amount == 2'b10) ? shift_right_1 :
                                   shift_right_8;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        q <= next_q;
    end
end

endmodule