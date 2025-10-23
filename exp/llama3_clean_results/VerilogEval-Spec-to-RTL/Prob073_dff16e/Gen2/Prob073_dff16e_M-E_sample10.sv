module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    reg [15:0] next_q;

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'd0;
        end else begin
            next_q = q;
            if (byteena[1]) begin
                next_q[15:8] = d[15:8];
            end
            if (byteena[0]) begin
                next_q[7:0] = d[7:0];
            end
            q <= next_q;
        end
    end

endmodule