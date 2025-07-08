module TopModule (
    input clk,
    input d,
    input q,       // input q as specified, though not used in DFF behavior
    output reg q_out
);

always @(posedge clk) begin
    q_out <= d;
end

endmodule