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
reg [3:0] remaining_time;
reg [9:0] clock_cycles;
reg [3:0] pattern;
reg [3:0] state;

localparam IDLE = 4'd0;
localparam DELAY_READ = 4'd1;
localparam COUNTING = 4'd2;
localparam DONE = 4'd3;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'd0;
        delay <= 4'd0;
        remaining_time <= 4'd0;
        clock_cycles <= 10'd0;
        count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern[3] <= 1'b1;
                    if (pattern == 4'd13) begin
                        state <= DELAY_READ;
                        pattern <= 4'd0;
                    end else begin
                        {pattern[2:0], pattern[3]} <= pattern[3:0];
                    end
                end else begin
                    {pattern[2:0], pattern[3]} <= {1'b0, pattern[3:1]};
                end
            end
            DELAY_READ: begin
                delay[3] <= data;
                if (pattern == 4'd4) begin
                    state <= COUNTING;
                    remaining_time <= delay + 1;
                    count <= remaining_time;
                    counting <= 1'b1;
                    pattern <= 4'd0;
                end else begin
                    {pattern[2:0], pattern[3]} <= pattern[3:0];
                    {delay[2:0], delay[3]} <= {delay[3:0], data};
                end
            end
            COUNTING: begin
                if (clock_cycles == 10'd999) begin
                    clock_cycles <= 10'd0;
                    if (remaining_time == 1) begin
                        state <= DONE;
                        done <= 1'b1;
                        counting <= 1'b0;
                    end else begin
                        remaining_time <= remaining_time - 1;
                    end
                    count <= remaining_time;
                end else begin
                    clock_cycles <= clock_cycles + 1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule