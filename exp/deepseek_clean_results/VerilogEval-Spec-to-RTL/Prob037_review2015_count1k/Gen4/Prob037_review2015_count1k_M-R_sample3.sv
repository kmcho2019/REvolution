module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] counter_reg;
wire [9:0] next_count;

// Combinational next-state logic
assign next_count = (counter_reg == 10'd999) ? 10'd0 : (counter_reg + 10'd1);

// Sequential state storage
always @(posedge clk) begin
    if (reset) begin
        counter_reg <= 10'd0;
    end
    else begin
        counter_reg <= next_count;
    end
end

// Output assignment
assign q = counter_reg;

endmodule