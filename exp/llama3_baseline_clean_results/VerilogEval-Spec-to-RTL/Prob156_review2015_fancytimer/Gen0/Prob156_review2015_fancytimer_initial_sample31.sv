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
reg [9:0] counter;
reg [3:0] remaining_time;

// Define states
localparam IDLE = 4'h0;
localparam SHIFT_DELAY = 4'h1;
localparam COUNTING = 4'h2;
localparam DONE = 4'h3;

// Define shift register for detecting pattern
reg [3:0] shift_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_reg <= 4'h0;
        delay <= 4'h0;
        counter <= 10'h0;
        remaining_time <= 4'h0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'h0;
    end else begin
        case (state)
            IDLE: begin
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg == 4'hD) begin
                    state <= SHIFT_DELAY;
                    shift_reg <= 4'h0;
                end
            end
            SHIFT_DELAY: begin
                delay <= {delay[2:0], data};
                if (shift_reg == 4'h4) begin
                    state <= COUNTING;
                    shift_reg <= 4'h0;
                    counter <= 10'h3E8; // 1000 in decimal
                    remaining_time <= delay;
                    counting <= 1'b1;
                end else begin
                    shift_reg <= shift_reg + 1;
                end
            end
            COUNTING: begin
                if (counter == 10'h0) begin
                    if (remaining_time == 4'h0) begin
                        state <= DONE;
                        counting <= 1'b0;
                    end else begin
                        remaining_time <= remaining_time - 1;
                        counter <= 10'h3E8; // 1000 in decimal
                    end
                end else begin
                    counter <= counter - 1;
                end
                count <= remaining_time;
            end
            DONE: begin
                done <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule