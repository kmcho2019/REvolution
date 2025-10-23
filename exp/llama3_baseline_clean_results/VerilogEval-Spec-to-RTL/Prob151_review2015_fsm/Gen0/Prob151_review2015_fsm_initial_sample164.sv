module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [3:0] shift_counter;
reg [3:0] state;

parameter IDLE = 4'b0000, SHIFT = 4'b0001, COUNT = 4'b0010, DONE_WAIT = 4'b0011, ACK_WAIT = 4'b0100;

reg [3:0] data_reg;
reg [3:0] data_shifted;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        data_reg <= 0;
        data_shifted <= 0;
        shift_counter <= 0;
    end else begin
        case(state)
            IDLE: begin
                if(data_reg == 4'b1101) begin
                    state <= SHIFT;
                    shift_ena <= 1;
                    data_shifted <= 0;
                    shift_counter <= 0;
                end else begin
                    data_reg <= {data_reg[2:0], data};
                end
            end
            SHIFT: begin
                shift_ena <= 1;
                data_shifted <= {data_shifted[2:0], data};
                shift_counter <= shift_counter + 1;
                if(shift_counter == 3) begin
                    state <= COUNT;
                    shift_ena <= 0;
                    counting <= 1;
                end
            end
            COUNT: begin
                counting <= 1;
                if(done_counting) begin
                    state <= DONE_WAIT;
                    counting <= 0;
                    done <= 1;
                end
            end
            DONE_WAIT: begin
                done <= 1;
                if(ack) begin
                    state <= ACK_WAIT;
                    done <= 0;
                end
            end
            ACK_WAIT: begin
                if(ack) begin
                    state <= IDLE;
                    data_reg <= 0;
                    data_shifted <= 0;
                    shift_counter <= 0;
                end
            end
        endcase
    end
end

endmodule