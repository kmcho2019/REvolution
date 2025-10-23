module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg first_one_seen;

// Combinational logic to determine output z based on current state and input
assign z = (first_one_seen) ? ~x : 0;

// Sequential logic to update state (first_one_seen) on positive edge of clk
always @(posedge clk or posedge areset) begin
    if (areset) begin
        first_one_seen <= 0;
    end else if (~first_one_seen && x) begin
        first_one_seen <= 1;
    end
end

endmodule