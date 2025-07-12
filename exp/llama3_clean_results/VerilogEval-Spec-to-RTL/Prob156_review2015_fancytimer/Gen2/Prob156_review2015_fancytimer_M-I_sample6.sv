module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [1:0] state;  // 0: Waiting, 1: Shifting, 2: Counting, 3: Done
reg [3:0] delay;  // Delay value
reg [9:0] counter;  // Counter for counting and clock cycles
reg counting_reg;  // Counting signal
reg done_reg;  // Done signal
reg [3:0] shift_reg;  // Shift register for input data

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        delay <= 0;
        counter <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        shift_reg <= 0;
    end else begin
        case (state)
            2'b00: begin  // Waiting for start pattern
                if (shift_reg == 4'b1101) begin
                    state <= 2'b01;
                    shift_reg <= 0;
                end else begin
                    shift_reg <= {shift_reg[2:0], data};
                end
            end
            2'b01: begin  // Shifting in delay value
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg == 4'b0000) begin
                    delay <= shift_reg;
                    state <= 2'b10;
                    counter <= (delay + 1) * 1000 - 1;
                    counting_reg <= 1;
                end
            end
            2'b10: begin  // Counting down delay
                if (counter == 0) begin
                    state <= 2'b11;
                    counting_reg <= 0;
                end else begin
                    counter <= counter - 1;
                end
            end
            2'b11: begin  // Waiting for acknowledgment
                done_reg <= 1;
                if (ack) begin
                    state <= 2'b00;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 2'b10) ? (counter / 1000) : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule