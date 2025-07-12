module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] delay;  // delay value
reg [3:0] remaining;  // remaining time
reg [3:0] shift_reg;  // shift register
reg [3:0] count_out;  // output count
reg counting_out;  // output counting flag
reg done_out;  // output done flag
reg [1:0] state;  // state register
reg [9:0] counter;  // counter for counting

parameter IDLE = 2'b00;
parameter SHIFTING = 2'b01;
parameter COUNTING = 2'b10;
parameter DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0000;
        remaining <= 4'b0000;
        shift_reg <= 4'b0000;
        count_out <= 4'b0000;
        counting_out <= 1'b0;
        done_out <= 1'b0;
        counter <= 10'b0000000000;
    end
    else begin
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    state <= SHIFTING;
                    shift_reg <= 4'b0000;
                end
                else if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end
                else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end
            SHIFTING: begin
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg[3]) begin
                    state <= COUNTING;
                    delay <= shift_reg;
                    remaining <= delay;
                    count_out <= delay;
                    counting_out <= 1'b1;
                end
            end
            COUNTING: begin
                counter <= counter + 1'b1;
                if (counter == 10'b1111111111) begin
                    counter <= 10'b0000000000;
                    if (remaining > 4'b0000) begin
                        remaining <= remaining - 1'b1;
                        count_out <= remaining;
                    end
                    else begin
                        state <= DONE;
                        counting_out <= 1'b0;
                        done_out <= 1'b1;
                    end
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_out <= 1'b0;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

assign count = count_out;
assign counting = counting_out;
assign done = done_out;

endmodule