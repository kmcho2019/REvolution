module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] counter;
reg [9:0] clock_counter;
reg [3:0] remaining_time;
reg shift_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000; // IDLE
        delay <= 4'b0000;
        counter <= 4'b0000;
        clock_counter <= 10'b0000000000;
        remaining_time <= 4'b0000;
        shift_reg <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            4'b0000: begin // IDLE
                if (shift_reg == 1'b1) begin
                    if (data == 1'b1) begin
                        shift_reg <= 1'b1;
                        if (counter == 4'b1101) begin
                            state <= 4'b0001; // SHIFT
                            counter <= 4'b0000;
                        end else begin
                            counter <= {counter[2:0], data};
                        end
                    end else begin
                        shift_reg <= 1'b0;
                        counter <= 4'b0000;
                    end
                end else begin
                    if (data == 1'b1) begin
                        shift_reg <= 1'b1;
                        counter <= {3'b000, data};
                    end
                end
            end
            4'b0001: begin // SHIFT
                delay[3:0] <= {delay[2:0], data};
                counter <= counter + 1'b1;
                if (counter == 4'b1000) begin
                    state <= 4'b0010; // COUNT
                    clock_counter <= 10'b0000000000;
                    remaining_time <= delay + 1'b1;
                end
            end
            4'b0010: begin // COUNT
                counting <= 1'b1;
                clock_counter <= clock_counter + 1'b1;
                if (clock_counter == 10'b1111101000) begin
                    clock_counter <= 10'b0000000000;
                    remaining_time <= remaining_time - 1'b1;
                    if (remaining_time == 4'b0000) begin
                        state <= 4'b0011; // DONE
                        counting <= 1'b0;
                    end
                end
                count <= remaining_time;
            end
            4'b0011: begin // DONE
                done <= 1'b1;
                if (ack == 1'b1) begin
                    state <= 4'b0000; // IDLE
                    done <= 1'b0;
                end
            end
            default: state <= 4'b0000;
        endcase
    end
end

endmodule