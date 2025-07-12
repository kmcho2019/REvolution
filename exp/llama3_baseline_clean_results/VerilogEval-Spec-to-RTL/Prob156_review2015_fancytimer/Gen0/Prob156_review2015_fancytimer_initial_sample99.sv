module TopModule (
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
reg [9:0] cycle_count;
reg counting_reg;
reg done_reg;
reg [3:0] pattern;
reg [3:0] pattern_shift;

reg [1:0] state;
localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNT = 2'b10;
localparam DONE = 2'b11;

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 0;
        count_reg <= 0;
        cycle_count <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        pattern <= 0;
        pattern_shift <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    pattern_shift <= 0;
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            SHIFT: begin
                pattern_shift <= pattern_shift + 1;
                delay <= {data, delay[3:1]};
                if (pattern_shift == 4) begin
                    state <= COUNT;
                    count_reg <= delay;
                    cycle_count <= 0;
                    counting_reg <= 1;
                end
            end
            COUNT: begin
                cycle_count <= cycle_count + 1;
                if (cycle_count == 1000) begin
                    cycle_count <= 0;
                    count_reg <= count_reg - 1;
                end
                if (count_reg == 0) begin
                    state <= DONE;
                    done_reg <= 1;
                    counting_reg <= 0;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 0;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

assign count = (state == COUNT) ? count_reg : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule