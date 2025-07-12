module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Rule 110 LUT: index = {left, center, right}
    // Index bits: 2=left, 1=center, 0=right
    // From the problem:
    // 111->0,110->1,101->1,100->0,011->1,010->1,001->1,000->0
    localparam [7:0] RULE110_LUT = 8'b01101110;

    wire [511:0] left_shifted, center, right_shifted;
    wire [2:0] lut_idx [511:0];
    wire [511:0] next_q;

    assign center = q;

    // Left neighbor: q[i+1] except boundary q[511]'s left = 0
    assign left_shifted = {q[510:0], 1'b0};

    // Right neighbor: q[i-1] except boundary q[0]'s right = 0
    assign right_shifted = {1'b0, q[511:1]};

    genvar i;
    generate
        for (i = 0; i < 512; i = i +1) begin : NEXT_STATE_GEN
            // lut_idx[i] = {left, center, right}
            assign lut_idx[i] = {left_shifted[i], center[i], right_shifted[i]};
            // Use LUT: RULE110_LUT indexed by lut_idx[i]
            assign next_q[i] = RULE110_LUT[lut_idx[i]];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule