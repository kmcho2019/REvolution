module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] remaining;
reg [9:0] counter;

localparam IDLE = 4'd0;
localparam SHIFT_DELAY = 4'd1;
localparam COUNTING = 4'd2;
localparam DONE = 4'd3;
localparam RESET = 4'd4;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'd0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    state <= IDLE + 1;
                end else begin
                    state <= IDLE;
                end
            end
            IDLE + 1: begin
                if (data == 1'b1) begin
                    state <= IDLE + 2;
                end else begin
                    state <= IDLE;
                end
            end
            IDLE + 2: begin
                if (data == 1'b0) begin
                    state <= IDLE + 3;
                end else begin
                    state <= IDLE;
                end
            end
            IDLE + 3: begin
                if (data == 1'b1) begin
                    state <= SHIFT_DELAY;
                end else begin
                    state <= IDLE;
                end
            end
            SHIFT_DELAY: begin
                delay[3] <= data;
                state <= SHIFT_DELAY + 1;
            end
            SHIFT_DELAY + 1: begin
                delay[2] <= data;
                state <= SHIFT_DELAY + 2;
            end
            SHIFT_DELAY + 2: begin
                delay[1] <= data;
                state <= SHIFT_DELAY + 3;
            end
            SHIFT_DELAY + 3: begin
                delay[0] <= data;
                state <= COUNTING;
                counting <= 1'b1;
                remaining <= delay;
                counter <= 10'd0;
            end
            COUNTING: begin
                if (counter == 10'd999) begin
                    counter <= 10'd0;
                    if (remaining == 4'd0) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        remaining <= remaining - 1;
                    end
                end else begin
                    counter <= counter + 1;
                end
                count <= remaining;
            end
            DONE: begin
                if (ack == 1'b1) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule