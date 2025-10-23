module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output [15:0] q
);

reg [15:0] q;

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'd0; // reset all DFFs when resetn is low
    end else begin
        if (byteena[0]) begin
            q[7:0] <= d[7:0]; // update lower byte if byteena[0] is set
        end
        if (byteena[1]) begin
            q[15:8] <= d[15:8]; // update upper byte if byteena[1] is set
        end
    end
end

endmodule