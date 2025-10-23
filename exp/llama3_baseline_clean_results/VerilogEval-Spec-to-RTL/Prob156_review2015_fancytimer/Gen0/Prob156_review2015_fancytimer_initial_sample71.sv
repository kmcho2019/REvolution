module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] remaining;
reg [9:0] cycle_counter;
reg [3:0] count_out;
reg counting_out;
reg done_out;

// State machine states
parameter IDLE = 4'd0;
parameter SHIFT_BITS = 4'd1;
parameter COUNT = 4'd2;
parameter DONE = 4'd3;

// Shift register for detecting the pattern 1101
reg [3:0] shift_register;

// Counting output
assign counting = counting_out;
assign done = done_out;
assign count = count_out;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_register <= 4'd0;
        cycle_counter <= 10'd0;
        remaining <= 4'd0;
        count_out <= 4'd0;
        counting_out <= 1'b0;
        done_out <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                shift_register <= {data, shift_register[3:1]};
                if (shift_register == 4'd13) begin
                    state <= SHIFT_BITS;
                end else begin
                    state <= IDLE;
                end
            end
            SHIFT_BITS: begin
                shift_register <= {data, shift_register[3:1]};
                if (shift_register[3:0] != 4'd0) begin
                    delay <= shift_register[3:0];
                    state <= COUNT;
                    remaining <= delay + 1;
                    cycle_counter <= 10'd0;
                    counting_out <= 1'b1;
                end else begin
                    state <= IDLE;
                end
            end
            COUNT: begin
                cycle_counter <= cycle_counter + 1;
                if (cycle_counter == 10'd999) begin
                    cycle_counter <= 10'd0;
                    remaining <= remaining - 1;
                    if (remaining == 4'd0) begin
                        state <= DONE;
                        counting_out <= 1'b0;
                    end
                end
                count_out <= remaining;
            end
            DONE: begin
                done_out <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                    done_out <= 1'b0;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule