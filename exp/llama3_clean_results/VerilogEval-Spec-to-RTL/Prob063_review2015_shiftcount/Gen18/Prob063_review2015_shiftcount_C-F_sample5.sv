module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

// Perform shift operation
reg [3:0] shift_out;
always @(*) begin
    shift_out = {q_reg[2:0], data};
end

// Perform decrement operation
reg [3:0] dec_out;
always @(*) begin
    dec_out = q_reg - 1;
end

// Update q_reg based on shift_ena and count_ena
always @(posedge clk) begin
    if (shift_ena) begin
        q_reg <= shift_out;
    end else if (count_ena) begin
        q_reg <= dec_out;
    end
end

assign q = q_reg;

endmodule