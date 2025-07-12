// TopModule with Integrated Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg [3:0] out_internal,
    output out
);

assign out = out_internal[3];

always @(posedge clk) begin
    if (!resetn) begin
        out_internal <= 4'b0000;
    end else begin
        out_internal <= {out_internal[2:0], in};
    end
end

endmodule