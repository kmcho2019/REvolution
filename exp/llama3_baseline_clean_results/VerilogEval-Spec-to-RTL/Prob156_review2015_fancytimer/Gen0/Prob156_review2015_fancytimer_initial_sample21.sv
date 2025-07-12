module TopModule (
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] delay;
reg [3:0] counter;
reg [2:0] shift_counter;
reg [3:0] count_reg;
reg counting_reg;
reg done_reg;
reg [3:0] state_counter;
reg [3:0] sequence;

always @(posedge clk) begin
    if (reset) begin
        delay <= 4'b0;
        counter <= 4'b0;
        shift_counter <= 3'b0;
        count_reg <= 4'b0;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
        state_counter <= 4'b0;
        sequence <= 4'b0;
    end else begin
        case (sequence)
            4'b1101: begin
                sequence <= 4'b0;
                if (shift_counter == 3'b0) begin
                    delay[3] <= data;
                    shift_counter <= shift_counter + 1'b1;
                end else if (shift_counter == 3'b1) begin
                    delay[2] <= data;
                    shift_counter <= shift_counter + 1'b1;
                end else if (shift_counter == 3'b2) begin
                    delay[1] <= data;
                    shift_counter <= shift_counter + 1'b1;
                end else if (shift_counter == 3'b3) begin
                    delay[0] <= data;
                    shift_counter <= 3'b0;
                    state_counter <= (delay + 1'b1) * 4'b1000;
                    counting_reg <= 1'b1;
                    count_reg <= delay;
                end
            end
            default: begin
                if (data == 1'b1) begin
                    sequence <= {sequence[2:0], 1'b1};
                end else begin
                    sequence <= {sequence[2:0], 1'b0};
                end
            end
        endcase

        if (counting_reg == 1'b1) begin
            if (state_counter == 4'b0) begin
                counting_reg <= 1'b0;
                done_reg <= 1'b1;
            end else begin
                state_counter <= state_counter - 1'b1;
                if (state_counter[0] == 1'b0) begin
                    count_reg <= count_reg - 1'b1;
                end
            end
        end

        if (done_reg == 1'b1 && ack == 1'b1) begin
            done_reg <= 1'b0;
        end
    end
end

assign count = counting_reg ? count_reg : 4'b0;
assign counting = counting_reg;
assign done = done_reg;

endmodule