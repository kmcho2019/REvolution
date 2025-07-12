module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Parameters for clock gating threshold
parameter CLK_GATE_THRESH = 8'hFF;

// Internal signals
wire [15:0] next_count;
wire [7:0] lower_count;
wire [7:0] upper_count;
wire carry_out;

// Clock gating control
wire gate_lower_clk = (count[15:8] == 8'h00) && !up_down || 
                     (count[15:8] == 8'hFF) && up_down;

// Lower 8-bit counter (ripple carry)
always @(posedge (gate_lower_clk ? 1'b0 : clk) begin
    if (reset) begin
        lower_count <= 8'b0;
    end else begin
        lower_count <= up_down ? lower_count + 1'b1 : lower_count - 1'b1;
    end
end

// Upper 8-bit counter (carry lookahead)
wire [7:0] upper_delta = up_down ? 8'h01 : 8'hFF;
wire [7:0] upper_p = count[15:8] ^ upper_delta;
wire [7:0] upper_g = count[15:8] & upper_delta;
wire [7:0] upper_c;

assign upper_c[0] = carry_out;
assign upper_c[1] = upper_g[0] | (upper_p[0] & carry_out);
assign upper_c[2] = upper_g[1] | (upper_p[1] & upper_g[0]) | 
                   (upper_p[1] & upper_p[0] & carry_out);
assign upper_c[3] = upper_g[2] | (upper_p[2] & upper_g[1]) | 
                   (upper_p[2] & upper_p[1] & upper_g[0]) | 
                   (upper_p[2] & upper_p[1] & upper_p[0] & carry_out);
assign upper_c[7:4] = 4'b0; // Simplified for area

always @(posedge clk) begin
    if (reset) begin
        upper_count <= 8'b0;
    end else begin
        upper_count <= upper_p ^ upper_c;
    end
end

// Carry out from lower to upper
assign carry_out = (up_down & (&lower_count)) || (!up_down & (lower_count == 8'h00));

// Final output
always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        count <= {upper_count, lower_count};
    end
end

endmodule