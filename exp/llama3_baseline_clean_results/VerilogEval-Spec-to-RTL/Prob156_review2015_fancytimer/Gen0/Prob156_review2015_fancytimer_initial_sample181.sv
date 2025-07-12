module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] delay;
reg [3:0] remaining_time;
reg [9:0] counter;
reg [3:0] pattern;
reg [2:0] shift_counter;
reg counting_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        pattern <= 0;
        shift_counter <= 0;
        delay <= 0;
        remaining_time <= 0;
        counter <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (pattern)
            4'b0000: begin
                if (data) begin
                    pattern <= pattern << 1 | data;
                end else begin
                    pattern <= 0;
                end
            end
            4'b1101: begin
                if (shift_counter < 4) begin
                    delay[shift_counter] <= data;
                    shift_counter <= shift_counter + 1;
                    pattern <= 0;
                end else begin
                    counting_reg <= 1;
                    remaining_time <= delay + 1;
                    counter <= 0;
                end
            end
            default: begin
                if (data) begin
                    pattern <= pattern << 1 | data;
                end else begin
                    pattern <= 0;
                end
            end
        endcase

        if (counting_reg) begin
            if (counter < 1000) begin
                counter <= counter + 1;
                count <= remaining_time;
            end else begin
                counter <= 0;
                remaining_time <= remaining_time - 1;
                if (remaining_time == 0) begin
                    counting_reg <= 0;
                    done_reg <= 1;
                end
            end
        end

        if (done_reg && ack) begin
            done_reg <= 0;
        end
    end
end

assign counting = counting_reg;
assign done = done_reg;

endmodule