module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

wire [15:0] next_count;
wire [15:0] increment = up_down ? 16'h0001 : 16'hFFFF; // +1 or -1 (two's complement)
wire [16:0] carry_prop;

// Generate carry using Kogge-Stone parallel prefix structure
assign carry_prop[0] = 1'b0;
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : carry_gen
        wire [16:0] g_p;
        assign g_p = {1'b0, count[i] & increment[i], count[i] ^ increment[i]};
        
        // First level: generate and propagate
        wire [16:0] stage1;
        assign stage1 = g_p | (g_p << 1 & {17{g_p[0]}});
        
        // Second level
        wire [16:0] stage2;
        assign stage2 = stage1 | (stage1 << 2 & {17{stage1[1]}});
        
        // Third level
        wire [16:0] stage3;
        assign stage3 = stage2 | (stage2 << 4 & {17{stage2[3]}});
        
        // Fourth level
        wire [16:0] stage4;
        assign stage4 = stage3 | (stage3 << 8 & {17{stage3[7]}});
        
        assign carry_prop[i+1] = stage4[i+1];
    end
endgenerate

// Calculate next count value
assign next_count = count ^ increment ^ carry_prop[15:0];

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        count <= next_count;
    end
end

endmodule