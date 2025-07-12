module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] delay;
reg [11:0] counter;
reg [3:0] remaining;
reg [3:0] state;
reg [3:0] shift_reg;

// Define states
localparam IDLE = 4'd0;
localparam SHIFT_DELAY = 4'd1;
localparam COUNTING = 4'd2;
localparam DONE = 4'd3;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'd0;
        counter <= 12'd0;
        remaining <= 4'd0;
        shift_reg <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (shift_reg == 4'd13) begin // 1101
                    state <= SHIFT_DELAY;
                    shift_reg <= 4'd0;
                end else if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end
            SHIFT_DELAY: begin
                if (shift_reg == 4'd4) begin
                    delay <= {data, shift_reg[3:1]};
                    state <= COUNTING;
                    counter <= {8'd0, delay} + 12'd1000;
                    remaining <= delay;
                end else begin
                    shift_reg <= shift_reg + 1'b1;
                end
            end
            COUNTING: begin
                if (counter == 12'd0) begin
                    state <= DONE;
                end else begin
                    counter <= counter - 12'd1;
                    if (counter[0] == 1'b0) begin
                        remaining <= remaining - 1'b1;
                    end
                end
                counting <= 1'b1;
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                end
                done <= 1'b1;
            end
        endcase
    end
end

assign count = remaining;

endmodule