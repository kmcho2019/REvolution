module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= 2'd0;
            out_bytes <= 24'd0;
            done_reg  <= 1'b0;
        end else begin
            done_reg <= 1'b0;  // Default done low

            case(state)
                2'd0: begin
                    if (in[3]) begin
                        out_bytes <= {in, 16'd0};
                        state     <= 2'd1;
                    end
                end
                2'd1: begin
                    out_bytes <= {out_bytes[23:16], in, 8'd0};
                    state     <= 2'd2;
                end
                2'd2: begin
                    out_bytes <= {out_bytes[23:8], in};
                    done_reg  <= 1'b1;  // Signal done for one cycle
                    state     <= 2'd0;
                end
            endcase
        end
    end

    always @(posedge clk) begin
        done <= done_reg;
    end

endmodule