module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    reg [15:0] reg_q;

    always @(posedge clk) begin
        if (!resetn) begin
            reg_q <= 16'h0000;
        end else begin
            // Upper byte (bits 15:8)
            if (byteena[1]) begin
                reg_q[15:8] <= d[15:8];
            end
            // Lower byte (bits 7:0)
            if (byteena[0]) begin
                reg_q[7:0] <= d[7:0];
            end
        end
    end

    assign q = reg_q;

endmodule