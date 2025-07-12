module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [3:0] remaining;
reg [3:0] count_reg;
reg [3:0] shift_reg;
reg [2:0] state;

// State machine states
localparam IDLE = 3'b000;
localparam SHIFT = 3'b001;
localparam COUNT = 3'b010;
localparam DONE = 3'b011;

// Initialize state machine to IDLE
initial state = IDLE;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0;
        remaining <= 4'b0;
        count_reg <= 4'b0;
        shift_reg <= 4'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    if (shift_reg == 4'b1101) begin
                        state <= SHIFT;
                    end else begin
                        shift_reg <= {data, shift_reg[3:1]};
                    end
                end else begin
                    shift_reg <= {data, shift_reg[3:1]};
                end
            end
            SHIFT: begin
                delay <= {data, delay[3:1]};
                if (delay[0] == 1'b1) begin
                    state <= COUNT;
                    remaining <= (delay + 1) * 4'b1000;
                    count_reg <= delay;
                    counting <= 1'b1;
                end
            end
            COUNT: begin
                if (remaining == 4'b0) begin
                    state <= DONE;
                    done <= 1'b1;
                    counting <= 1'b0;
                end else begin
                    remaining <= remaining - 1'b1;
                    if (remaining[0] == 1'b0) begin
                        count_reg <= count_reg - 1'b1;
                    end
                end
            end
            DONE: begin
                if (ack == 1'b1) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

always @(*) begin
    if (state == COUNT) begin
        count = count_reg;
    end else begin
        count = 4'b0;
    end
end

endmodule