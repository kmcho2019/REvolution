module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count_reg;
wire [3:0] next_count;

// Combinational next state logic
assign next_count = count_reg + 1'b1;

// Sequential state update with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        count_reg <= 4'b0000;
    end else begin
        count_reg <= next_count;
    end
end

// Output assignment
assign q = count_reg;

endmodule