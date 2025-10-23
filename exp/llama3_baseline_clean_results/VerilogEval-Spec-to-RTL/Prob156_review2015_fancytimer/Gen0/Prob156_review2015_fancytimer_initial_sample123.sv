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
reg [3:0] current_count;
reg [9:0] clock_count;
reg [3:0] shift_reg;
reg counting_reg;
reg done_reg;
reg [1:0] state;

parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0000;
        current_count <= 4'b0000;
        clock_count <= 10'b0000000000;
        shift_reg <= 4'b0000;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1 && shift_reg == 4'b1101) begin
                    state <= SHIFT;
                    shift_reg <= 4'b0000;
                end else if (data == 1'b1) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else if (data == 1'b0) begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end
            SHIFT: begin
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg == 4'b1000) begin
                    delay <= shift_reg;
                    state <= COUNT;
                    current_count <= delay;
                    clock_count <= 10'b0000000000;
                    counting_reg <= 1'b1;
                end
            end
            COUNT: begin
                clock_count <= clock_count + 1;
                if (clock_count == 10'd999) begin
                    clock_count <= 10'b0000000000;
                    current_count <= current_count - 1;
                    if (current_count == 4'b0000) begin
                        state <= DONE;
                        counting_reg <= 1'b0;
                    end
                end
            end
            DONE: begin
                done_reg <= 1'b1;
                if (ack == 1'b1) begin
                    state <= IDLE;
                    done_reg <= 1'b0;
                end
            end
        endcase
    end
end

assign count = (state == COUNT) ? current_count : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule