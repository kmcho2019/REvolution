module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_reg; // Output register

// Use a single always block to handle the flip-flop
always @(posedge clk or negedge clk)
begin
    if (clk) begin
        q_reg <= d;
    end else begin
        q_reg <= d;
    end
end

// Use the output register as the output
assign q = q_reg;

endmodule