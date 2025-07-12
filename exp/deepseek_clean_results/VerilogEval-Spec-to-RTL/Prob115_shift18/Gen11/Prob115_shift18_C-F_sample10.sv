module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control signals
wire shift_right = amount[1];
wire shift_8 = amount[0];
wire do_shift = ena & ~load;

// Shift logic
wire [63:0] shifted_value;
wire [63:0] sign_ext = {64{q[63]}}; // Only used when shifting right

// Barrel shifter implementation
assign shifted_value = shift_right ? 
                      // Arithmetic right shift
                      ((shift_8 ? {sign_ext[7:0], q[63:8]} : {sign_ext[0], q[63:1]}) :
                      // Left shift
                      (shift_8 ? {q[55:0], 8'b0} : {q[62:0], 1'b0});

// Clock-gated update logic
always @(posedge clk) begin
    if (load)
        q <= data;
    else if (ena)
        q <= shifted_value;
end

endmodule