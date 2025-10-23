module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg msb_bit;
    reg lsb_bit;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            msb_bit <= data[99];
            lsb_bit <= data[0];
        end else begin
            case (ena)
                2'b01: begin // rotate right
                    lsb_bit <= q[0];
                    q <= {lsb_bit, q[99:1]};
                    msb_bit <= q[99];
                end
                2'b10: begin // rotate left
                    msb_bit <= q[99];
                    q <= {q[98:0], msb_bit};
                    lsb_bit <= q[0];
                end
                default: begin // no rotate
                    q <= q;
                    msb_bit <= msb_bit;
                    lsb_bit <= lsb_bit;
                end
            endcase
        end
    end

endmodule