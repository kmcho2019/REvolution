module TopModule (
    input           clk,
    input           reset,
    input           data,
    output  [3:0]    count,
    output          counting,
    output          done,
    input           ack
);

reg [3:0]          delay;
reg [3:0]          counter;
reg [9:0]          timer_counter;
reg [3:0]          time_remaining;
reg [3:0]          shift_register;
reg               counting_reg;
reg               done_reg;
reg               idle;
reg               shift;
reg               counting_state;
reg               done_state;

always @(posedge clk) begin
    if (reset) begin
        idle <= 1;
        shift <= 0;
        counting_state <= 0;
        done_state <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        shift_register <= 0;
        counter <= 0;
        timer_counter <= 0;
        time_remaining <= 0;
        delay <= 0;
    end else begin
        if (idle) begin
            if (shift_register == 4'b1101) begin
                idle <= 0;
                shift <= 1;
                shift_register <= 0;
            end else begin
                shift_register <= {shift_register[2:0], data};
            end
        end else if (shift) begin
            shift_register <= {shift_register[2:0], data};
            counter <= counter + 1;
            if (counter == 4) begin
                shift <= 0;
                counting_state <= 1;
                delay <= shift_register;
                timer_counter <= 0;
                time_remaining <= delay;
                counting_reg <= 1;
            end
        end else if (counting_state) begin
            timer_counter <= timer_counter + 1;
            if (timer_counter == 1000) begin
                timer_counter <= 0;
                time_remaining <= time_remaining - 1;
                if (time_remaining == 0) begin
                    counting_state <= 0;
                    done_state <= 1;
                    done_reg <= 1;
                    counting_reg <= 0;
                end
            end
        end else if (done_state) begin
            if (ack) begin
                done_state <= 0;
                idle <= 1;
                done_reg <= 0;
            end
        end
    end
end

assign count = (counting_state) ? time_remaining : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule