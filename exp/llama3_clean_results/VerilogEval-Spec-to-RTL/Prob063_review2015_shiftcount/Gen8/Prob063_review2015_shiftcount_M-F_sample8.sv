module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

// Decrement logic
wire [3:0] dec_val;
assign dec_val = (q_reg == 4'b0000) ? 4'b1111 : q_reg - 1;

// Shift logic
wire [3:0] shift_val;
assign shift_val = {data, q_reg[3:1]};

// Update register value
always @(posedge clk) begin
    if (shift_ena) begin
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        q_reg <= dec_val;
    end
end

// Output assignment
assign q = q_reg;

// Initialize register value
initial begin
    q_reg = 4'b0000;
end

endmodule