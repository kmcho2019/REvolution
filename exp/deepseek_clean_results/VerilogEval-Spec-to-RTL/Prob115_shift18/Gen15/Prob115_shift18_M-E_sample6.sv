module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-compute all possible shift patterns
wire [63:0] shift_left_1  = {q[62:0], 1'b0};
wire [63:0] shift_left_8  = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = { {1{q[63]}}, q[63:1] };
wire [63:0] shift_right_8 = { {8{q[63]}}, q[63:8] };

// Select shift operation based on amount
reg [63:0] shifted_val;
always @(*) begin
    case (amount)
        2'b00: shifted_val = shift_left_1;
        2'b01: shifted_val = shift_left_8;
        2'b10: shifted_val = shift_right_1;
        2'b11: shifted_val = shift_right_8;
    endcase
end

// Update register
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else if (ena) begin
        q <= shifted_val;
    end
end

endmodule