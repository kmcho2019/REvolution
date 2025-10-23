module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] delay; // delay value
reg [9:0] counter; // counter for clock cycles
reg [3:0] current_count; // current count value
reg counting_reg; // counting output
reg done_reg; // done output
reg [3:0] shift_reg; // shift register for input sequence
reg seq_bit; // bit to check for input sequence

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        counting_reg <= 0;
        done_reg <= 0;
        delay <= 0;
        counter <= 0;
        current_count <= 0;
        shift_reg <= 0;
        seq_bit <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (shift_reg == 4'b1101) begin
                    state <= 1; // move to SHIFT state
                    shift_reg <= 0;
                end else begin
                    shift_reg <= {data, shift_reg[2:0]}; // shift in input sequence
                end
            end
            1: begin // SHIFT state
                delay <= {data, delay[2:0]}; // shift in delay value
                if (delay[0] == 1'b1) begin // check if all 4 bits have been shifted
                    state <= 2; // move to COUNT state
                    counting_reg <= 1;
                    counter <= delay * 1000;
                    current_count <= delay;
                end
            end
            2: begin // COUNT state
                counter <= counter - 1;
                if (counter == 0) begin
                    current_count <= current_count - 1;
                    if (current_count == 0) begin
                        state <= 3; // move to DONE state
                        counting_reg <= 0;
                    end else begin
                        counter <= 1000;
                    end
                end
            end
            3: begin // DONE state
                done_reg <= 1;
                if (ack) begin // check for acknowledgement
                    state <= 0; // reset to IDLE state
                    done_reg <= 0;
                    counting_reg <= 0;
                    delay <= 0;
                    counter <= 0;
                    current_count <= 0;
                    shift_reg <= 0;
                    seq_bit <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;
assign count = current_count;

endmodule