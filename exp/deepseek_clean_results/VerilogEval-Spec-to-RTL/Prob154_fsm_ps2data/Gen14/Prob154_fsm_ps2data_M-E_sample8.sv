module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_counter;
    reg [23:0] shift_reg;
    reg waiting_for_start;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b0;
            shift_reg <= 24'bx;
            done <= 1'b0;
            waiting_for_start <= 1'b1;
        end else begin
            done <= 1'b0;
            
            if (waiting_for_start) begin
                if (in[3]) begin
                    shift_reg[23:16] <= in;
                    byte_counter <= 2'b01;
                    waiting_for_start <= 1'b0;
                end
            end else begin
                case (byte_counter)
                    2'b01: begin
                        shift_reg[15:8] <= in;
                        byte_counter <= 2'b10;
                    end
                    2'b10: begin
                        shift_reg[7:0] <= in;
                        byte_counter <= 2'b11;
                    end
                    2'b11: begin
                        out_bytes <= shift_reg;
                        done <= 1'b1;
                        byte_counter <= 2'b00;
                        waiting_for_start <= 1'b1;
                    end
                endcase
            end
        end
    end

endmodule