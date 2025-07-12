module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Clock gating control
wire clk_en = load || (ena != 2'b00 && ena != 2'b11);
wire gated_clk;

// Clock gating cell
CLKGATE x_clkgate (
    .CK(clk),
    .E(clk_en),
    .ECK(gated_clk)
);

// Rotation logic
wire [99:0] next_q;
wire do_rotate = ~load && (ena == 2'b01 || ena == 2'b10);
wire rotate_left = ena[1];

// Logarithmic barrel shifter implementation
wire [99:0] rot_stage [0:6];
assign rot_stage[0] = q;

// Rotation stages (64,32,16,8,4,2,1)
genvar i;
generate
    for (i = 0; i < 7; i = i + 1) begin : rotate_stages
        assign rot_stage[i+1] = do_rotate && rotate_left ? 
            {rot_stage[i][99-(1<<i):0], rot_stage[i][99:100-(1<<i)]} :
            {rot_stage[i][(1<<i)-1:0], rot_stage[i][99:(1<<i)]};
    end
endgenerate

// Next state logic
assign next_q = load ? data : rot_stage[7];

// Synchronous update with gated clock
always @(posedge gated_clk) begin
    q <= next_q;
end

endmodule