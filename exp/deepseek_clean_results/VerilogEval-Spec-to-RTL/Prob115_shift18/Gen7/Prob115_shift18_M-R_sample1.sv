module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-compute all possible shift results in parallel
wire [63:0] left_shift1  = q << 1;
wire [63:0] left_shift8  = q << 8;
wire [63:0] right_shift1 = {q[63], q[63:1]};  // Arithmetic right shift by 1
wire [63:0] right_shift8 = {{8{q[63]}}, q[63:8]};  // Arithmetic right shift by 8

// Select appropriate shift result based on amount
wire [63:0] shifted_value = 
    (amount == 2'b00) ? left_shift1 :
    (amount == 2'b01) ? left_shift8 :
    (amount == 2'b10) ? right_shift1 :
                        right_shift8;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        q <= shifted_value;
    end
end

endmodule