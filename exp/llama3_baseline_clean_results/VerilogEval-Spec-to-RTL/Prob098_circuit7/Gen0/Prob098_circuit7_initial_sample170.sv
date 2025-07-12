module TopModule (
    input clk,
    input a,
    output q
);

reg q_reg = 1'b0; // Initialize output to 0
reg prev_a = 1'b0; // Initialize previous value of a to 0

always @(posedge clk) begin
    prev_a <= a; // Store current value of a
end

always @(posedge clk) begin
    if (prev_a == 1'b0 && a == 1'b0) begin
        q_reg <= 1'b1; // Set q to 1 when a has been 0
    end else if (a == 1'b1) begin
        q_reg <= 1'b0; // Reset q to 0 when a is 1
    end
end

assign q = q_reg;

endmodule