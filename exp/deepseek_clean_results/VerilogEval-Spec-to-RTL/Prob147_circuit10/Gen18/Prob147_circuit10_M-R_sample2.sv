module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

wire state_in;
wire state_en;
wire state_rst;
wire [1:0] zero_count;

// State register (D flip-flop with enable and reset)
reg state_reg = 1'b0;
always @(posedge clk) begin
    if (state_rst)
        state_reg <= 1'b0;
    else if (state_en)
        state_reg <= state_in;
end

// Next state logic
assign state_in = ~state_reg;

// Enable logic - toggle when a != b
assign state_en = (a ^ b) & ~state_rst;

// Reset logic - after 4 consecutive a=0 & b=0
assign zero_count = (a | b) ? 2'b0 : (zero_count + 1);
assign state_rst = (zero_count == 2'b11);

// Output logic
assign q = state_reg ^ b;
assign state = state_reg;

endmodule