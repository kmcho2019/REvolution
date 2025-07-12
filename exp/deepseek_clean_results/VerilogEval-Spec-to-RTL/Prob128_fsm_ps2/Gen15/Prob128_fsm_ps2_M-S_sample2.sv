module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] state;  // 00: waiting, 01: byte1, 10: byte2

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    done <= 1'b0;
                    if (in[3]) state <= 2'b01;
                end
                2'b01: begin
                    done <= 1'b0;
                    state <= 2'b10;
                end
                2'b10: begin
                    done <= 1'b1;
                    state <= 2'b00;
                end
            endcase
        end
    end

endmodule