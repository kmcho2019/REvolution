module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk, posedge reset) begin
    if (reset) begin
        q <= 8'h34;  // reset to 0x34
    end else if (~$fell(clk)) begin  // using $fell to check for negative edge of clk
        // do nothing, only update q on negative edge
    end else begin
        q <= d;  // update q with d on negative edge of clk
    end
end

endmodule