module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] count_reg;
reg counting_reg;
reg done_reg;
reg [3:0] delay_reg;
reg [3:0] remaining_time_reg;
reg [2:0] pattern_reg;
reg [2:0] shift_reg;
reg [3:0] counter_reg;
reg start_count;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 4'b0000;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
        delay_reg <= 4'b0000;
        remaining_time_reg <= 4'b0000;
        pattern_reg <= 3'b000;
        shift_reg <= 3'b000;
        counter_reg <= 4'b0000;
        start_count <= 1'b0;
    end else begin
        case (pattern_reg)
            3'b000: begin
                if (data) begin
                    pattern_reg <= 3'b001;
                end
            end
            3'b001: begin
                if (data) begin
                    pattern_reg <= 3'b011;
                end else begin
                    pattern_reg <= 3'b000;
                end
            end
            3'b011: begin
                if (data) begin
                    pattern_reg <= 3'b110;
                end else begin
                    pattern_reg <= 3'b000;
                end
            end
            3'b110: begin
                if (data) begin
                    pattern_reg <= 3'b101;
                    shift_reg <= 3'b001;
                end else begin
                    pattern_reg <= 3'b000;
                end
            end
            3'b101: begin
                if (shift_reg == 3'b100) begin
                    delay_reg <= {data, delay_reg[3:1]};
                    start_count <= 1'b1;
                    counting_reg <= 1'b1;
                    remaining_time_reg <= delay_reg + 1'b1;
                    pattern_reg <= 3'b000;
                end else begin
                    delay_reg <= {data, delay_reg[3:1]};
                    shift_reg <= shift_reg + 1'b1;
                end
            end
            default: begin
                pattern_reg <= 3'b000;
            end
        endcase

        if (start_count) begin
            if (counter_reg == 4'b1000) begin
                counter_reg <= 4'b0000;
                if (remaining_time_reg > 4'b0000) begin
                    remaining_time_reg <= remaining_time_reg - 1'b1;
                end else begin
                    counting_reg <= 1'b0;
                    done_reg <= 1'b1;
                    start_count <= 1'b0;
                end
            end else begin
                counter_reg <= counter_reg + 1'b1;
            end
        end

        if (ack && done_reg) begin
            done_reg <= 1'b0;
            pattern_reg <= 3'b000;
        end
    end
end

assign count = remaining_time_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule