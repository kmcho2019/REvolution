module TopModule(
    input wire clk,
    input wire d,
    output reg q
);

always_ff @(posedge clk) begin
    q <= d;
end

endmodule