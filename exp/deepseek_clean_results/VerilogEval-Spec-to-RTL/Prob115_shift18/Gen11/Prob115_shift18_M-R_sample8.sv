module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

// Internal register
reg [63:0] shift_reg;

// Control signals
wire do_load = load;
wire do_shift = ena & ~load;
wire shift_right = amount[1];
wire [7:0] sign_ext = {8{shift_reg[63]}};  // Only computed when needed

// Shift operations
wire [63:0] shift_result = 
    shift_right ? 
        (amount[0] ? {sign_ext, shift_reg[63:8]} : {shift_reg[63], shift_reg[63:1]}) :
        (amount[0] ? {shift_reg[55:0], 8'b0}     : {shift_reg[62:0], 1'b0});

// Next state logic
wire [63:0] next_shift_reg = 
    do_load ? data : (do_shift ? shift_result : shift_reg);

// Register update with clock
always @(posedge clk) begin
    shift_reg <= next_shift_reg;
end

// Continuous output assignment
assign q = shift_reg;

endmodule