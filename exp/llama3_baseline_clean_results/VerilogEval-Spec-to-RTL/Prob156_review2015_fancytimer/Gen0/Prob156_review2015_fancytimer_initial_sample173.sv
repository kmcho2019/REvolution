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
reg [3:0] counter;
reg [9:0] timer;
reg [3:0] count_out;
reg start_seq;
reg [3:0] shift_reg;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam START_SEQUENCE = 2'b01;
localparam SHIFTING = 2'b10;
localparam COUNTING = 2'b11;
localparam DONE = 2'b10;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        start_seq <= 1'b0;
        shift_reg <= 4'b0000;
        counter <= 4'b0000;
        timer <= 10'b0000000000;
        count_out <= 4'b0000;
        done <= 1'b0;
        counting <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (start_seq) begin
                    state <= START_SEQUENCE;
                    start_seq <= 1'b0;
                end else if (data == 1'b1 && shift_reg == 4'b1101) begin
                    start_seq <= 1'b1;
                end else if (data == 1'b1) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else if (data == 1'b0) begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end
            START_SEQUENCE: begin
                state <= SHIFTING;
            end
            SHIFTING: begin
                if (counter == 4'b1000) begin
                    state <= COUNTING;
                    timer <= {delay, 4'b1000};
                    counter <= 4'b0000;
                    count_out <= delay;
                end else begin
                    delay <= {delay[2:0], data};
                    counter <= counter + 1;
                end
            end
            COUNTING: begin
                if (timer == 10'b0000000000) begin
                    state <= DONE;
                end else begin
                    timer <= timer - 1;
                    if (counter == 4'b1000) begin
                        count_out <= count_out - 1;
                        counter <= 4'b0000;
                    end else begin
                        counter <= counter + 1;
                    end
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

always @(*) begin
    case (state)
        IDLE: begin
            count <= 4'bx;
            counting <= 1'b0;
            done <= 1'b0;
        end
        START_SEQUENCE: begin
            count <= 4'bx;
            counting <= 1'b0;
            done <= 1'b0;
        end
        SHIFTING: begin
            count <= 4'bx;
            counting <= 1'b0;
            done <= 1'b0;
        end
        COUNTING: begin
            count <= count_out;
            counting <= 1'b1;
            done <= 1'b0;
        end
        DONE: begin
            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b1;
        end
    endcase
end

endmodule