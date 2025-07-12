module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Parameters for shift amounts
parameter SHIFT_LEFT1 = 2'b00;
parameter SHIFT_LEFT8 = 2'b01;
parameter SHIFT_RIGHT1 = 2'b10;
parameter SHIFT_RIGHT8 = 2'b11;

wire [63:0] shift_left1 = {q[62:0], 1'b0};
wire [63:0] shift_left8 = {q[55:0], 8'b0};
wire [63:0] shift_right1 = {q[63], q[63:1]};
wire [63:0] shift_right8 = {{8{q[63]}}, q[63:8]};

reg [63:0] next_q;

always @(*) begin
    case (amount)
        SHIFT_LEFT1:   next_q = shift_left1;
        SHIFT_LEFT8:   next_q = shift_left8;
        SHIFT_RIGHT1:  next_q = shift_right1;
        SHIFT_RIGHT8:  next_q = shift_right8;
        default:       next_q = q;
    endcase
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        q <= next_q;
    end
end

endmodule