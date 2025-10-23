module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [3:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        bit_counter <= 0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        case(bit_counter)
            0: begin // IDLE
                if (!in) begin
                    bit_counter <= 1;
                end
            end
            1: begin // START
                bit_counter <= 2;
            end
            2: begin // DATA
                out_byte[7 - (bit_counter - 2)] <= in;
                if (bit_counter == 9) begin
                    if (in) begin // STOP
                        done <= 1;
                    end
                    bit_counter <= 0;
                end
                else begin
                    bit_counter <= bit_counter + 1;
                end
            end
            default: begin
                done <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (bit_counter == 0) begin
        done <= 0;
    end
end

endmodule