module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

reg [7:0] q_high;
reg [7:0] q_low;

always @(posedge clk) begin
    if (!resetn) begin
        q_high <= 8'd0;
        q_low <= 8'd0;
    end else begin
        if (byteena[1]) begin
            q_high <= d[15:8];
        end
        if (byteena[0]) begin
            q_low <= d[7:0];
        end
    end
end

assign q = {q_high, q_low};

endmodule