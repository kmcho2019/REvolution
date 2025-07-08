module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    typedef enum reg [1:0] {IDLE=2'd0, BYTE1=2'd1, BYTE2=2'd2} state_t;
    reg [7:0] byte1, byte2, byte3;
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            case(state)
                IDLE: begin
                    if (in[3] == 1'b1) begin
                        byte1 <= in;
                        state <= BYTE1;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                    state <= BYTE2;
                end
                BYTE2: begin
                    byte3 <= in;
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule