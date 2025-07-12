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
reg [3:0] count_reg;
reg [11:0] counter;
reg [3:0] shift_reg;
reg counting_reg;
reg done_reg;
reg [1:0] state;

parameter IDLE = 2'b00;
parameter SHIFTING = 2'b01;
parameter COUNTING = 2'b10;
parameter DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0000;
        count_reg <= 4'b0000;
        counter <= 12'b0000;
        shift_reg <= 4'b0000;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    state <= SHIFTING;
                end
                else if (data == 1'b1) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end
                else if (data == 1'b0) begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end
            SHIFTING: begin
                if (counter == 4'b1000) begin
                    state <= COUNTING;
                    delay <= shift_reg;
                    counter <= 12'b0000;
                    count_reg <= delay;
                end
                else begin
                    counter <= counter + 1;
                    shift_reg <= {data, shift_reg[3:1]};
                end
            end
            COUNTING: begin
                if (counter == 12'b1111101000) begin
                    if (count_reg == 1'b0) begin
                        state <= DONE;
                        counting_reg <= 1'b0;
                    end
                    else begin
                        count_reg <= count_reg - 1;
                        counter <= 12'b0000;
                    end
                end
                else begin
                    counter <= counter + 1;
                    counting_reg <= 1'b1;
                end
            end
            DONE: begin
                if (ack == 1'b1) begin
                    state <= IDLE;
                    done_reg <= 1'b0;
                end
            end
        endcase
    end
end

assign count = count_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule