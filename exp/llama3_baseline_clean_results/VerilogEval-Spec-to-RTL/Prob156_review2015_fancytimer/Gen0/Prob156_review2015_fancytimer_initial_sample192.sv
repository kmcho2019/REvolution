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
reg [3:0] remaining;
reg [11:0] total_count;
reg [3:0] shift_reg;
reg [3:0] state;
reg [3:0] pattern;

// States
parameter IDLE = 4'b0001;
parameter SHIFTING = 4'b0010;
parameter COUNTING = 4'b0011;
parameter DONE = 4'b0100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_reg <= 4'b0000;
        delay <= 4'b0000;
        remaining <= 4'b0000;
        total_count <= 12'b0000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
                if (pattern == 4'b1101) begin
                    state <= SHIFTING;
                    shift_reg <= 4'b0000;
                end else begin
                    state <= IDLE;
                end
            end
            SHIFTING: begin
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg[0] == 1'b1) begin
                    delay <= shift_reg;
                    state <= COUNTING;
                    remaining <= delay;
                    total_count <= 12'b0000;
                    counting <= 1'b1;
                end else begin
                    state <= SHIFTING;
                end
            end
            COUNTING: begin
                if (total_count == (delay + 1'b1) * 1000 - 1) begin
                    state <= DONE;
                    counting <= 1'b0;
                    done <= 1'b1;
                end else begin
                    total_count <= total_count + 1'b1;
                    if (total_count % 1000 == 0) begin
                        remaining <= remaining - 1'b1;
                    end
                    state <= COUNTING;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                    pattern <= 4'b0000;
                end else begin
                    state <= DONE;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

assign count = (state == COUNTING) ? remaining : 4'bxxxx;

endmodule