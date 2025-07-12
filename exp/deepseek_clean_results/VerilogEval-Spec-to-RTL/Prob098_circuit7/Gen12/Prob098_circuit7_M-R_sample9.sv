module TopModule (
    input clk,
    input a,
    output q
);

wire inverted_a;
reg q_reg;

// Combinational logic
assign inverted_a = ~a;

// Sequential logic
always @(posedge clk) begin
    q_reg <= inverted_a;
end

assign q = q_reg;

endmodule