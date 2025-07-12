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
reg [2:0] pattern_reg;
reg [2:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        pattern_reg <= 0;
        shift_reg <= 0;
        delay_reg <= 0;
        count_reg <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (pattern_reg)
            3'b000: begin // IDLE
                if (data == 1) begin
                    pattern_reg <= pattern_reg + 1;
                end
            end
            3'b001: begin // SHIFT_PATTERN
                if (data == 1) begin
                    pattern_reg <= pattern_reg + 1;
                end else begin
                    pattern_reg <= 0;
                end
            end
            3'b010: begin // SHIFT_PATTERN
                if (data == 0) begin
                    pattern_reg <= pattern_reg + 1;
                end else begin
                    pattern_reg <= 0;
                end
            end
            3'b011: begin // SHIFT_PATTERN
                if (data == 1) begin
                    pattern_reg <= 0;
                    shift_reg <= 1;
                end else begin
                    pattern_reg <= 0;
                end
            end
            default: begin
                // unused states
            end
        endcase

        if (shift_reg != 0) begin // SHIFT_DELAY
            if (shift_reg == 4) begin
                delay_reg <= {data, delay_reg[2:0]};
                shift_reg <= 0;
                count_reg <= delay_reg + 1;
                counting_reg <= 1;
            end else begin
                delay_reg <= {data, delay_reg[2:0]};
                shift_reg <= shift_reg + 1;
            end
        end

        if (counting_reg == 1) begin // COUNTING
            if (count_reg == 0) begin
                count_reg <= delay_reg;
                counting_reg <= 0;
                done_reg <= 1;
            end else begin
                count_reg <= count_reg - 1;
            end
        end

        if (done_reg == 1 && ack == 1) begin // DONE
            done_reg <= 0;
            pattern_reg <= 0;
        end
    end
end

assign count = (counting_reg == 1) ? delay_reg - (delay_reg + 1 - count_reg) : 0;
assign counting = counting_reg;
assign done = done_reg;

endmodule