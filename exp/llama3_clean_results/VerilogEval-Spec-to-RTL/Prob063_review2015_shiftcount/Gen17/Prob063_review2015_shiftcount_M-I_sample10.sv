module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

// Perform shift and decrement operations in parallel
reg [3:0] shift_out;
reg [3:0] dec_out;

always @(*) begin
    // Shift operation
    shift_out = {q_reg[2:0], data};
    
    // Decrement operation
    dec_out = q_reg - 1;
end

always @(posedge clk) begin
    if (shift_ena) begin
        // Select shift output when shift_ena is 1
        q_reg <= shift_out;
    end else if (count_ena) begin
        // Select decrement output when count_ena is 1
        q_reg <= dec_out;
    end
end

assign q = q_reg;

endmodule