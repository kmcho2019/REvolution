module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a == 1'b0) begin
        q <= 1'b1;
    end else if (q == 1'b1) begin // This models the transition from 1 to 0 when a goes to 1
        q <= 1'b0;
    end
end

endmodule