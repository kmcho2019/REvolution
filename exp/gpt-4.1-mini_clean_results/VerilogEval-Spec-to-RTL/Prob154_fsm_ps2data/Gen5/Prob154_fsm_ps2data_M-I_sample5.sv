module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] count;              // 0=no message, 1=byte1, 2=byte2, 3=byte3 received
    reg [7:0] byte1_reg, byte2_reg, byte3_reg;
    reg done_pending;

    always @(posedge clk) begin
        if (reset) begin
            count      <= 2'd0;
            done       <= 1'b0;
            done_pending <= 1'b0;
            out_bytes  <= 24'b0;
            byte1_reg  <= 8'b0;
            byte2_reg  <= 8'b0;
            byte3_reg  <= 8'b0;
        end else begin
            done <= done_pending;       // Assert done only for one cycle
            done_pending <= 1'b0;       // Clear done after one cycle

            case (count)
                2'd0: begin
                    // Look for start byte with in[3] == 1
                    if (in[3]) begin
                        byte1_reg <= in;
                        count <= 2'd1;
                    end
                end
                2'd1: begin
                    byte2_reg <= in;
                    count <= 2'd2;
                end
                2'd2: begin
                    byte3_reg <= in;
                    out_bytes <= {byte1_reg, byte2_reg, in};
                    done_pending <= 1'b1;
                    count <= 2'd0; // Ready for next message
                end
                default: begin
                    count <= 2'd0;
                end
            endcase
        end
    end

endmodule