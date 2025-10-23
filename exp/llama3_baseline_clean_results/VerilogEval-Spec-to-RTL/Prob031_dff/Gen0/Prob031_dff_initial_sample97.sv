module TopModule(
    input clk,
    input d,
    output reg q
);

always_ff @(posedge clk) begin
    q <= d;
end

endmodule