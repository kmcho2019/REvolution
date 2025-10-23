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

    reg [1:0] state;
    reg [1:0] count;
    reg shift_ena_reg;
    reg counting_reg;
    reg done_reg;

    // State encoding
    parameter IDLE = 2'b00;
    parameter SHIFT = 2'b01;
    parameter COUNT = 2'b10;
    parameter DONE = 2'b11;

    // Pattern detection
    reg [3:0] pattern;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0000;
            count <= 2'b00;
            shift_ena_reg <= 1'b0;
            counting_reg <= 1'b0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                        count <= 2'b00;
                    end
                end
                SHIFT: begin
                    shift_ena_reg <= 1'b1;
                    count <= count + 1;
                    if (count == 2'b11) begin
                        shift_ena_reg <= 1'b0;
                        state <= COUNT;
                    end
                end
                COUNT: begin
                    counting_reg <= 1'b1;
                    if (done_counting) begin
                        counting_reg <= 1'b0;
                        state <= DONE;
                    end
                end
                DONE: begin
                    done_reg <= 1'b1;
                    if (ack) begin
                        done_reg <= 1'b0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign shift_ena = shift_ena_reg;
    assign counting = counting_reg;
    assign done = done_reg;

endmodule