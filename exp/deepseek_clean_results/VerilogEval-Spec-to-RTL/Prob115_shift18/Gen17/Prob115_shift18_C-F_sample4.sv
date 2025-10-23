module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signals with clock gating
wire do_shift = ena & ~load;
wire shift_left = ~amount[1] & do_shift;
wire shift_right = amount[1] & do_shift;
wire shift_amount = amount[0] ? 3'd7 : 3'd0; // 8 or 1 bit shift

// Shared sign extension for right shifts
wire sign_bit = q[63];
wire [7:0] sign_ext = {8{sign_bit}};

// Barrel shifter implementation
wire [63:0] shifted_val;
assign shifted_val = shift_left ? (q << (shift_amount + 1)) : 
                    shift_right ? ({sign_ext, q[63:shift_amount+1]}) : q;

// Next state logic with priority to load
wire [63:0] next_q = load ? data : shifted_val;

// Register update with clock gating
always @(posedge clk) begin
    if (load || ena) begin
        q <= next_q;
    end
end

endmodule