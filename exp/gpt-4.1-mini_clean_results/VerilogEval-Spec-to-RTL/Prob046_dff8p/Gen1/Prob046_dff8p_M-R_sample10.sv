module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

genvar i;
wire [7:0] q_int;

generate
    for (i = 0; i < 8; i = i + 1) begin : dffs
        reg q_bit;
        always @(negedge clk) begin
            if (reset)
                q_bit <= 8'h34[i];
            else
                q_bit <= d[i];
        end
        assign q_int[i] = q_bit;
    end
endgenerate

assign q = q_int;

endmodule