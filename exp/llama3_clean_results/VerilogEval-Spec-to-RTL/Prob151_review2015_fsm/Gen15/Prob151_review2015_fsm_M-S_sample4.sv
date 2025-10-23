module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] pattern_reg;
reg [1:0] shift_cnt;

always @(posedge clk) begin
    if (reset) begin
        pattern_reg <= 0;
        shift_cnt <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        pattern_reg <= {pattern_reg[2:0], data};

        if (pattern_reg == 4'b1101 && shift_cnt == 0) begin
            shift_ena <= 1;
            shift_cnt <= 1;
        end
        else if (shift_ena && shift_cnt < 4) begin
            shift_cnt <= shift_cnt + 1;
        end
        else if (shift_cnt == 4) begin
            shift_ena <= 0;
            counting <= 1;
        end
        else if (counting && done_counting) begin
            counting <= 0;
            done <= 1;
        end
        else if (done && ack) begin
            done <= 0;
            pattern_reg <= 0;
            shift_cnt <= 0;
        end
    end
end

endmodule