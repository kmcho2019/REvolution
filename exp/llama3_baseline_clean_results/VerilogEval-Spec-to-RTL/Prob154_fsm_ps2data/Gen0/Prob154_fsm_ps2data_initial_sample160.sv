module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

    reg [1:0] state;
    reg [23:0] msg;
    reg [7:0] byte1, byte2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            done <= 1'b0;
            out_bytes <= 24'b0;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
        end else begin
            case (state)
                2'b00: begin // IDLE
                    if (in[3] == 1'b1) begin
                        byte1 <= in;
                        state <= 2'b01;
                    end
                end
                2'b01: begin // WAIT_BYTE2
                    byte2 <= in;
                    state <= 2'b10;
                end
                2'b10: begin // WAIT_BYTE3
                    msg <= {in, byte2, byte1};
                    state <= 2'b11;
                end
                2'b11: begin // DONE
                    out_bytes <= msg;
                    done <= 1'b1;
                    state <= 2'b00;
                end
                default: state <= 2'b00;
            endcase
        end
    end

    always @(posedge clk) begin
        if (~reset && state != 2'b11) begin
            done <= 1'b0;
        end
    end

endmodule