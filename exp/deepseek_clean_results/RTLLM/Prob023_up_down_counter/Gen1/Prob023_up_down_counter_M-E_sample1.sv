module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Generate carry-lookahead groups
wire [15:0] next_count;
wire [3:0] carry_out;

// Conditional increment value (1 for up, -1 for down)
wire [15:0] delta = up_down ? 16'h0001 : 16'hFFFF;

// First level: 4-bit carry-lookahead adders
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : CLA_GROUP
        wire [3:0] group_count = count[i*4 +: 4];
        wire [3:0] group_delta = delta[i*4 +: 4];
        wire carry_in = (i == 0) ? 1'b0 : carry_out[i-1];
        
        // 4-bit carry-lookahead adder
        wire [3:0] sum;
        wire [3:0] g = group_count & group_delta;
        wire [3:0] p = group_count ^ group_delta;
        wire [3:0] c;
        
        assign c[0] = carry_in;
        assign c[1] = g[0] | (p[0] & carry_in);
        assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry_in);
        assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                     (p[2] & p[1] & p[0] & carry_in);
        assign carry_out[i] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                            (p[3] & p[2] & p[1] & g[0]) | 
                            (p[3] & p[2] & p[1] & p[0] & carry_in);
        
        assign sum = p ^ c;
        assign next_count[i*4 +: 4] = sum;
    end
endgenerate

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        count <= next_count;
    end
end

endmodule