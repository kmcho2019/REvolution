module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

wire [99:0] rotate_left;
wire [99:0] rotate_right;
wire [99:0] rotate_left_sel;
wire [99:0] rotate_right_sel;
wire [99:0] next_value;
wire        clk_en;

// Compute rotate left by 1: bits shifted left, MSB gets LSB
assign rotate_left = {q[98:0], q[99]};

// Compute rotate right by 1: bits shifted right, LSB gets MSB
assign rotate_right = {q[0], q[99:1]};

// Gated rotate vectors: only valid when corresponding ena bit is set, else zero vector
assign rotate_left_sel  = (ena == 2'b10) ? rotate_left  : {100{1'b0}};
assign rotate_right_sel = (ena == 2'b01) ? rotate_right : {100{1'b0}};

// Clock enable active when load or rotation enabled (ena == 01 or 10)
assign clk_en = load | (ena == 2'b01) | (ena == 2'b10);

// Next value mux: priority load > rotate left > rotate right > hold
// Since rotate_left_sel and rotate_right_sel are zero when not active,
// avoid unintended data by explicitly checking ena
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
    if (clk_en) begin
        q <= next_value;
    end
    // else hold q value implicitly (no assignment)
end

endmodule