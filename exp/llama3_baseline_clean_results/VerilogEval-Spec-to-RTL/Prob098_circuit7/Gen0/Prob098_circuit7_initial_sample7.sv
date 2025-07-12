module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a == 0) begin
        q <= 1; // When a is 0, q remains 1
    end else begin
        q <= 0; // When a is 1, q becomes 0 on the next clock edge
    end
end

endmodule