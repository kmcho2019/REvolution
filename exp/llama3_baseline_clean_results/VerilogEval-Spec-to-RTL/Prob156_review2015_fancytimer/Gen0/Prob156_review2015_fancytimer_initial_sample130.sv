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
reg [3:0] remaining_time;
reg [3:0] count_out;
reg counting_out;
reg done_out;
reg [3:0] shift_register;

// State machine
reg [2:0] state;
localparam IDLE = 3'b000;
localparam SHIFT = 3'b001;
localparam COUNT = 3'b010;
localparam DONE = 3'b011;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0000;
        remaining_time <= 4'b0000;
        count_out <= 4'b0000;
        counting_out <= 1'b0;
        done_out <= 1'b0;
        shift_register <= 4'b0000;
    end else begin
        case (state)
            IDLE: begin
                if (shift_register == 4'b1101) begin
                    state <= SHIFT;
                    shift_register <= 4'b0000;
                end else if (data) begin
                    shift_register <= {shift_register[2:0], 1'b1};
                end else begin
                    shift_register <= {shift_register[2:0], 1'b0};
                end
            end
            SHIFT: begin
                shift_register <= {shift_register[2:0], data};
                if (shift_register == 4'b1000) begin
                    delay <= shift_register;
                    state <= COUNT;
                    remaining_time <= delay + 1;
                    count_out <= delay;
                    counting_out <= 1'b1;
                end
            end
            COUNT: begin
                if (remaining_time > 1) begin
                    remaining_time <= remaining_time - 1;
                    if (remaining_time[1:0] == 2'b00) begin
                        count_out <= count_out - 1;
                    end
                end else begin
                    state <= DONE;
                    counting_out <= 1'b0;
                    done_out <= 1'b1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_out <= 1'b0;
                end
            end
        endcase
    end
end

assign count = count_out;
assign counting = counting_out;
assign done = done_out;

endmodule