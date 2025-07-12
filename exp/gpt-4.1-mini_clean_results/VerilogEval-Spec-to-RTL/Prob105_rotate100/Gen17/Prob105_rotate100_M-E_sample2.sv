module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

integer i;
reg rotated_out;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b01: begin // rotate right by 1
                rotated_out = q[0];
                // Shift right by 1 with rotation
                for (i = 0; i < 99; i = i + 1) begin
                    q[i] <= q[i + 1];
                end
                q[99] <= rotated_out;
            end
            2'b10: begin // rotate left by 1
                rotated_out = q[99];
                // Shift left by 1 with rotation
                for (i = 99; i > 0; i = i - 1) begin
                    q[i] <= q[i - 1];
                end
                q[0] <= rotated_out;
            end
            default: begin // 2'b00 or 2'b11: hold state
                q <= q;
            end
        endcase
    end
end

endmodule