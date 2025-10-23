module TopModule (
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
reg [3:0] shift_reg;
reg [9:0] counter_reg;
reg [3:0] sequence_reg;
integer i;

always @(posedge clk) begin
    if (reset) begin
        sequence_reg <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        counter_reg <= 0;
        shift_reg <= 0;
        delay_reg <= 0;
        count_reg <= 0;
    end else begin
        case (sequence_reg)
            4'b0000: begin // Idle
                if (data) begin
                    sequence_reg <= {sequence_reg[2:0], 1'b1};
                end else begin
                    sequence_reg <= {sequence_reg[2:0], 1'b0};
                end
                if (sequence_reg == 4'b1101) begin
                    sequence_reg <= 4'b0000;
                    shift_reg <= 4;
                end
            end
            4'b0001, 4'b0010, 4'b0011, 4'b0100: begin // Shift
                delay_reg[shift_reg-1] <= data;
                shift_reg <= shift_reg - 1;
                if (shift_reg == 0) begin
                    sequence_reg <= 4'b1000;
                    counter_reg <= 0;
                    counting_reg <= 1;
                end
            end
            4'b1000: begin // Counting
                if (counter_reg < ((delay_reg + 1) * 1000 - 1)) begin
                    counter_reg <= counter_reg + 1;
                    if (counter_reg % 1000 == 0) begin
                        count_reg <= count_reg - 1;
                    end
                end else begin
                    counting_reg <= 0;
                    done_reg <= 1;
                    sequence_reg <= 4'b1001;
                end
            end
            4'b1001: begin // Done
                if (ack) begin
                    done_reg <= 0;
                    sequence_reg <= 4'b0000;
                end
            end
        endcase
    end
end

assign count = (counting_reg) ? delay_reg : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule