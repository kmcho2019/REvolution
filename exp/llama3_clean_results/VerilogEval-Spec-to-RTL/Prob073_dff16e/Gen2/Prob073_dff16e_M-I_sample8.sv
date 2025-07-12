module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'd0;
    end else begin
        if (byteena[0]) begin
            q[7:0] <= #0 d[7:0]; // use non-blocking assignment
        end
        if (byteena[1]) begin
            q[15:8] <= #0 d[15:8]; // use non-blocking assignment
        end
    end
end

endmodule