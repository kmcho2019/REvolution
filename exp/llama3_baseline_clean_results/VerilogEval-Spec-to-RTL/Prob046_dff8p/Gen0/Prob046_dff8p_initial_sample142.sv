module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk or posedge reset) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

wire [7:0] reset_val = 8'h34;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_array
        DFF dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
        initial q[i] = reset_val[i];
    end
endgenerate

endmodule