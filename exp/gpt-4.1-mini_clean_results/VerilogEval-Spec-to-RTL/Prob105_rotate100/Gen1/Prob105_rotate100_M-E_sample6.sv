module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

wire [99:0] rotate_left, rotate_right;
wire [99:0] next_value;

// Compute rotate left by 1: bits shifted left, MSB gets LSB
assign rotate_left = {q[98:0], q[99]};

// Compute rotate right by 1: bits shifted right, LSB gets MSB
assign rotate_right = {q[0], q[99:1]};

// For each bit, select next value based on load and ena:
// Priority: load > ena control > hold
genvar i;
generate
    for (i=0; i<100; i=i+1) begin : gen_next
        assign next_value[i] = load        ? data[i]         :
                               (ena == 2'b10) ? rotate_left[i]  :
                               (ena == 2'b01) ? rotate_right[i] :
                               q[i];
    end
endgenerate

always @(posedge clk) begin
    q <= next_value;
end

endmodule