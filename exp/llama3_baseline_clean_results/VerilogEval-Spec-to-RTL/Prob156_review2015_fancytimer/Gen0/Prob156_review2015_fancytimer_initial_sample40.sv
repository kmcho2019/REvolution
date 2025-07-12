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
reg [9:0] counter;
reg [3:0] shift_reg;
reg done_reg;
reg counting_reg;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNT = 2'b10;
localparam DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
        counting_reg <= 1'b0;
        count_reg <= 4'b0;
        counter <= 10'b0;
        shift_reg <= 4'b0;
    end else begin
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    state <= SHIFT;
                    shift_reg <= 4'b0;
                end else begin
                    shift_reg <= {shift_reg[2:0], data};
                end
            end
            SHIFT: begin
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg[3] == 1'b1) begin
                    delay <= shift_reg[3:0];
                    state <= COUNT;
                    count_reg <= delay;
                    counter <= 10'b0;
                end
            end
            COUNT: begin
                counter <= counter + 1'b1;
                if (counter == 10'b1111101000) begin
                    counter <= 10'b0;
                    count_reg <= count_reg - 1'b1;
                    if (count_reg == 4'b0) begin
                        state <= DONE;
                    end
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 1'b0;
                end
            end
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;
assign count = count_reg;

always @(posedge clk) begin
    case (state)
        IDLE: begin
            counting_reg <= 1'b0;
        end
        COUNT: begin
            counting_reg <= 1'b1;
        end
        DONE: begin
            counting_reg <= 1'b0;
            done_reg <= 1'b1;
        end
        default: begin
            counting_reg <= 1'b0;
            done_reg <= 1'b0;
        end
    endcase
end

endmodule