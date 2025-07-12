module TopModule (
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state; // 0: Idle, 1: Shift, 2: Count, 3: Done
reg [3:0] delay; // delay value
reg [3:0] remaining; // remaining time
reg [9:0] counter; // counter for 1000 clock cycles
reg [3:0] count_out; // count output
reg counting_out; // counting output
reg done_out; // done output
reg [3:0] shift_reg; // shift register for pattern detection

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Idle
        delay <= 0;
        remaining <= 0;
        counter <= 0;
        count_out <= 0;
        counting_out <= 0;
        done_out <= 0;
        shift_reg <= 0;
    end else begin
        case (state)
            0: begin // Idle
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg == 4'b1101) begin
                    state <= 1; // Shift
                end
            end
            1: begin // Shift
                delay <= {data, delay[3:1]};
                if (delay[0] == 1'b1) begin // most significant bit
                    state <= 2; // Count
                    remaining <= delay + 1;
                    counter <= 0;
                    counting_out <= 1'b1;
                end
            end
            2: begin // Count
                counter <= counter + 1;
                if (counter == 10'd1000) begin
                    counter <= 0;
                    remaining <= remaining - 1;
                    if (remaining == 0) begin
                        state <= 3; // Done
                        counting_out <= 1'b0;
                        done_out <= 1'b1;
                    end
                end
                count_out <= remaining - 1;
            end
            3: begin // Done
                if (ack) begin
                    state <= 0; // Idle
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