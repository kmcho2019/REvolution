module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Upper byte (d[15:8]) controlled by byteena[1]
            if (byteena[1]) q[15:8] <= d[15:8];
            // Lower byte (d[7:0]) controlled by byteena[0]
            if (byteena[0]) q[7:0] <= d[7:0];
        end
    end

endmodule