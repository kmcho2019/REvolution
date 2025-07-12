module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] shift_reg;
wire [9:0] load_pattern;
integer i;

// Create a load_pattern with 'data' number of 1's shifted into the lower bits,
// e.g., if data=3, load_pattern=10'b0000000111
// This represents the count in unary form.
always @(*) begin
    load_pattern = 10'b0;
    for(i = 0; i < 10; i = i + 1) begin
        load_pattern[i] = (i < data) ? 1'b1 : 1'b0;
    end
end

always @(posedge clk) begin
    if (load) begin
        shift_reg <= load_pattern;  // Load unary count pattern
    end else if (shift_reg != 0) begin
        shift_reg <= shift_reg >> 1;  // Shift right to count down
    end
    // else hold zero (terminal count reached)
end

assign tc = (shift_reg == 0);

endmodule