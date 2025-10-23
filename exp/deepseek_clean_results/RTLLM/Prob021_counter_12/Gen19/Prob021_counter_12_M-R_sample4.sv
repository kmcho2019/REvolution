module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output wire [3:0] out
);

reg [3:0] count_reg;
wire [3:0] next_count;

// Next state logic
assign next_count = (count_reg == 4'd11) ? 4'b0 : 
                    (count_reg + 1'b1);

// Register update
always @(posedge clk) begin
    if (!rst_n)
        count_reg <= 4'b0;
    else if (valid_count)
        count_reg <= next_count;
end

// Output assignment
assign out = count_reg;

endmodule