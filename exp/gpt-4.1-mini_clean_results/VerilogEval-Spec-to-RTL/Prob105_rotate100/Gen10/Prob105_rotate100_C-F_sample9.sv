module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

wire [99:0] rotate_left, rotate_right;
wire [99:0] next_value;
wire        rotate_left_en = (ena == 2'b10);
wire        rotate_right_en = (ena == 2'b01);
wire        en_update = load | rotate_left_en | rotate_right_en;

// Compute rotate left by 1: bits shifted left, MSB gets LSB
assign rotate_left = {q[98:0], q[99]};

// Compute rotate right by 1: bits shifted right, LSB gets MSB
assign rotate_right = {q[0], q[99:1]};

// Determine next value based on load and ena control signals
genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin : next_val_gen
        assign next_value[i] = load          ? data[i]         :
                               rotate_left_en  ? rotate_left[i]  :
                               rotate_right_en ? rotate_right[i] :
                               q[i];
    end
endgenerate

always @(posedge clk) begin
    if (en_update)
        q <= next_value;
    // else hold q (no assignment), reducing switching activity
end

endmodule