module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [9:0] counter;
reg [3:0] state; // 0: idle, 1: shift, 2: counting, 3: done
reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // idle
        count <= 0;
        counting <= 0;
        done <= 0;
        shift_reg <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data) begin // data = 1
                    shift_reg <= {1'b1, shift_reg[2:0]};
                    if (shift_reg == 4'b1101) begin
                        state <= 1; // shift
                    end else if (shift_reg[3:1] == 3'b110) begin
                        shift_reg <= {1'b1, shift_reg[2:0]};
                    end else begin
                        shift_reg <= {1'b0, shift_reg[2:0]};
                    end
                end else begin // data = 0
                    shift_reg <= {1'b0, shift_reg[2:0]};
                end
            end
            1: begin // shift
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg[3:0] == 4'bxxxx) begin // 4 bits have been shifted in
                    delay <= shift_reg;
                    state <= 2; // counting
                    counter <= {6'b0, delay} + 10'b1000; // +1 * 1000
                    counting <= 1;
                end
            end
            2: begin // counting
                counter <= counter - 1;
                count <= delay - (9'd1000 - counter[9:4]);
                if (counter == 0) begin
                    state <= 3; // done
                    counting <= 0;
                    done <= 1;
                end
            end
            3: begin // done
                if (ack) begin
                    state <= 0; // idle
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule