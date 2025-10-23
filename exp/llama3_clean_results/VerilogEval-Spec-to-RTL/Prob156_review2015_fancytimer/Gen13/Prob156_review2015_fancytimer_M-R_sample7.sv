module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay_reg;
reg [19:0] counter;
reg [3:0] remaining_time;
reg [3:0] pattern_reg;
reg [2:0] state;

localparam IDLE = 3'b000;
localparam SHIFT = 3'b001;
localparam COUNT = 3'b010;
localparam DONE = 3'b011;
localparam RESET = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay_reg <= 0;
        counter <= 0;
        remaining_time <= 0;
        pattern_reg <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                pattern_reg <= {pattern_reg[2:0], data};
                if (pattern_reg == 4'b1101) begin
                    state <= SHIFT;
                    pattern_reg <= 0;
                end
            end
            SHIFT: begin
                delay_reg <= {data, delay_reg[3:1]};
                if (pattern_reg == 4'b1000) begin
                    state <= COUNT;
                    counter <= (delay_reg + 1) * 1000 - 1;
                    remaining_time <= delay_reg;
                    pattern_reg <= 0;
                    counting <= 1;
                end else begin
                    pattern_reg <= pattern_reg + 1;
                end
            end
            COUNT: begin
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        remaining_time <= remaining_time - 1;
                    end
                end else begin
                    state <= DONE;
                    counting <= 0;
                end
            end
            DONE: begin
                if (ack == 1'b1) begin
                    state <= RESET;
                    done <= 0;
                end else begin
                    done <= 1;
                end
            end
            RESET: begin
                state <= IDLE;
                delay_reg <= 0;
                counter <= 0;
                remaining_time <= 0;
                pattern_reg <= 0;
                done <= 0;
            end
        endcase
    end
end

assign count = remaining_time;

endmodule