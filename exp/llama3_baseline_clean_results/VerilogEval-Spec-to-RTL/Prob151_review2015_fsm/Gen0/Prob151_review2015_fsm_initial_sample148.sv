module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNTING, 3: DONE
reg [3:0] pattern_reg; // register to store the pattern detection state
reg [1:0] shift_counter; // counter to keep track of the number of bits shifted

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        pattern_reg <= 0;
        shift_counter <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1 && pattern_reg == 4'b1100) begin // pattern detected
                    state <= 1; // SHIFT
                    pattern_reg <= 0;
                end else if (data == 1 && pattern_reg == 4'b1000) begin
                    pattern_reg <= 4'b1100;
                end else if (data == 0 && pattern_reg == 4'b100) begin
                    pattern_reg <= 4'b1000;
                end else if (data == 1 && pattern_reg == 4'b10) begin
                    pattern_reg <= 4'b100;
                end else if (data == 1 && pattern_reg == 4'b1) begin
                    pattern_reg <= 4'b10;
                end else if (data == 1) begin
                    pattern_reg <= 4'b1;
                end else begin
                    pattern_reg <= 0;
                end
            end
            1: begin // SHIFT
                if (shift_counter == 2'd3) begin // 4 bits shifted
                    state <= 2; // COUNTING
                    shift_counter <= 0;
                end else begin
                    shift_counter <= shift_counter + 1;
                end
            end
            2: begin // COUNTING
                if (done_counting) begin
                    state <= 3; // DONE
                end
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0; // IDLE
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin // IDLE
            shift_ena = 0;
            counting = 0;
            done = 0;
        end
        1: begin // SHIFT
            shift_ena = 1;
            counting = 0;
            done = 0;
        end
        2: begin // COUNTING
            shift_ena = 0;
            counting = 1;
            done = 0;
        end
        3: begin // DONE
            shift_ena = 0;
            counting = 0;
            done = 1;
        end
    endcase
end

endmodule