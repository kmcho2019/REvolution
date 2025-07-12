module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // Upper byte (bits 15:8)
    always @(posedge clk) begin
        if (!resetn) begin
            q[15:8] <= 8'b0;
        end else if (byteena[1]) begin
            q[15:8] <= d[15:8];
        end
    end

    // Lower byte (bits 7:0)
    always @(posedge clk) begin
        if (!resetn) begin
            q[7:0] <= 8'b0;
        end else if (byteena[0]) begin
            q[7:0] <= d[7:0];
        end
    end

endmodule