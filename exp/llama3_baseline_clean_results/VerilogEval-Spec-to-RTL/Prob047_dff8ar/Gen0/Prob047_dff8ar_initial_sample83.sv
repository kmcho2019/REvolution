module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0; // reset to 0
    end else begin
        q <= d; // load data on positive edge of clk
    end
end

endmodule