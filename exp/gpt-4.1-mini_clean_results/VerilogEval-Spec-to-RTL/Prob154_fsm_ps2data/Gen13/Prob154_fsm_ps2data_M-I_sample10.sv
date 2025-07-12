module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state;
    reg [7:0] byte0, byte1, byte2;

    always @(posedge clk) begin
        if (reset) begin
            state     <= 2'd0;
            byte0     <= 8'd0;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;
            case(state)
                2'd0: begin
                    // Searching for first byte with in[3] = 1
                    if (in[3]) begin
                        byte0 <= in;
                        state <= 2'd1;
                    end
                end
                2'd1: begin
                    byte1 <= in;
                    state <= 2'd2;
                end
                2'd2: begin
                    byte2 <= in;
                    out_bytes <= {byte0, byte1, in};
                    done <= 1'b1;
                    state <= 2'd0;
                end
            endcase
        end
    end

endmodule