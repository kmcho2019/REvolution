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
reg [3:0] remaining_time;
reg [9:0] clock_counter;
reg [3:0] shift_register;
reg start_sequence_detected;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam SHIFTING = 2'b01;
localparam COUNTING = 2'b10;
localparam DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_sequence_detected <= 1'b0;
        shift_register <= 4'b0000;
        delay <= 4'b0000;
        remaining_time <= 4'b0000;
        clock_counter <= 10'b0000000000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (start_sequence_detected) begin
                    state <= SHIFTING;
                    shift_register <= 4'b0000;
                end else if (data == 1'b1) begin
                    // start sequence detection
                    if (shift_register == 4'b1101) begin
                        start_sequence_detected <= 1'b1;
                    end else begin
                        shift_register <= {shift_register[2:0], data};
                    end
                end else begin
                    shift_register <= {shift_register[2:0], data};
                end
            end
            SHIFTING: begin
                shift_register <= {shift_register[2:0], data};
                if (&shift_register[3:0]) begin
                    delay <= shift_register;
                    state <= COUNTING;
                    remaining_time <= delay;
                    clock_counter <= 10'b0000000000;
                    counting <= 1'b1;
                end
            end
            COUNTING: begin
                if (clock_counter == 10'd999) begin
                    remaining_time <= remaining_time - 1'b1;
                    clock_counter <= 10'b0000000000;
                end else begin
                    clock_counter <= clock_counter + 1'b1;
                end
                if (remaining_time == 4'b0000) begin
                    state <= DONE;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
                count <= remaining_time;
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    start_sequence_detected <= 1'b0;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule