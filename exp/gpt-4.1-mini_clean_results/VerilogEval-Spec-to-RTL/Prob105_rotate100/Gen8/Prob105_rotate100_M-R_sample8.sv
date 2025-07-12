module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

reg [99:0] next_q;

integer i;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b10: begin // rotate left
                // rotate left by 1: MSB gets LSB
                for (i = 0; i < 99; i = i +1) begin
                    next_q[i] = q[i+1];
                end
                next_q[99] = q[0];
                q <= next_q;
            end
            2'b01: begin // rotate right
                // rotate right by 1: LSB gets MSB
                for (i = 1; i < 100; i = i +1) begin
                    next_q[i] = q[i-1];
                end
                next_q[0] = q[99];
                q <= next_q;
            end
            default: begin
                // no rotation, hold value
                q <= q;
            end
        endcase
    end
end

endmodule