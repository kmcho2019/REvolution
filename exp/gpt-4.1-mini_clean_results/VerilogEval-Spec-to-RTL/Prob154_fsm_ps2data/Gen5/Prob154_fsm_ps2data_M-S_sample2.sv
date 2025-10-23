module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] count;
    reg [7:0] b1, b2;

    always @(posedge clk) begin
        if (reset) begin
            count     <= 2'd0;
            done      <= 1'b0;
            out_bytes <= 24'd0;
            b1        <= 8'd0;
            b2        <= 8'd0;
        end else begin
            done <= 1'b0;
            case (count)
                2'd0: begin
                    if (in[3]) begin
                        b1    <= in;
                        count <= 2'd1;
                    end
                end
                2'd1: begin
                    b2    <= in;
                    count <= 2'd2;
                end
                2'd2: begin
                    out_bytes <= {b1, b2, in};
                    done      <= 1'b1;
                    count     <= 2'd0;
                end
            endcase
        end
    end

endmodule