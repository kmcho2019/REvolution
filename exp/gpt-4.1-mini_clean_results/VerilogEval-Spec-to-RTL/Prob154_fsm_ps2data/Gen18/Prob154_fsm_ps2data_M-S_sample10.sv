module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Two states: WAIT for start byte, COLLECT next two bytes
    localparam WAIT = 1'b0, COLLECT = 1'b1;
    reg state;
    reg [1:0] count; // counts bytes received in current message: 0 to 3

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT;
            count <= 2'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low
            case (state)
                WAIT: begin
                    if (in[3]) begin
                        out_bytes <= {in, 16'd0};
                        count <= 2'd1;
                        state <= COLLECT;
                    end
                end
                COLLECT: begin
                    out_bytes <= {out_bytes[15:0], in};
                    count <= count + 1;
                    if (count == 2) begin
                        done <= 1'b1;
                        state <= WAIT;
                        count <= 2'd0;
                    end
                end
            endcase
        end
    end

endmodule