module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] remaining;
reg [9:0] counter;
reg counting_reg;
reg done_reg;

// State machine states
localparam IDLE = 4'b0000;
localparam SHIFT = 4'b0001;
localparam COUNTING = 4'b0010;
localparam DONE = 4'b0011;

// Shift register for input pattern detection
reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_reg <= 4'b0000;
        counter <= 10'b0000000000;
        remaining <= 4'b0000;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg == 4'b1101) begin
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                delay <= {delay[2:0], data};
                if (delay[0] == data) begin
                    state <= COUNTING;
                    remaining <= delay;
                    counter <= 10'b0000000000;
                    counting_reg <= 1'b1;
                end
            end
            COUNTING: begin
                if (counter == 10'b1111101000) begin // 1000 cycles
                    remaining <= remaining - 1;
                    counter <= 10'b0000000000;
                    if (remaining == 4'b0000) begin
                        state <= DONE;
                        counting_reg <= 1'b0;
                    end
                end else begin
                    counter <= counter + 1;
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

assign count = (state == COUNTING) ? remaining : 4'bxxxx;
assign counting = counting_reg;
assign done = (state == DONE) ? 1'b1 : 1'b0;

endmodule