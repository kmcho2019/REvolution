module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] counter;
reg [3:0] count_out;
reg [3:0] shift_reg;
reg [1:0] state;
reg [9:0] clock_counter;

// State machine states
localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNTING = 2'b10;
localparam DONE = 2'b11;

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count_out <= 4'b0;
        delay <= 4'b0;
        counter <= 4'b0;
        clock_counter <= 10'b0;
        done <= 1'b0;
        counting <= 1'b0;
        shift_reg <= 4'b0;
    end else begin
        case (state)
            IDLE: begin
                // Check for start pattern
                if (shift_reg == 4'b1101) begin
                    state <= SHIFT;
                    shift_reg <= 4'b0;
                end else if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end
            SHIFT: begin
                // Shift in delay bits
                if (counter == 4'b1000) begin
                    state <= COUNTING;
                    delay <= shift_reg;
                    counter <= 4'b0;
                    clock_counter <= 10'b0;
                    counting <= 1'b1;
                end else begin
                    shift_reg <= {data, shift_reg[3:1]};
                    counter <= counter + 1'b1;
                end
            end
            COUNTING: begin
                // Count down delay
                if (clock_counter == 10'b1111101000) begin
                    clock_counter <= 10'b0;
                    if (count_out == delay) begin
                        count_out <= delay - 1'b1;
                    end else if (count_out == 4'b0) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end else begin
                    clock_counter <= clock_counter + 1'b1;
                end
            end
            DONE: begin
                // Wait for acknowledgement
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                    count_out <= 4'b0;
                    delay <= 4'b0;
                    counter <= 4'b0;
                    clock_counter <= 10'b0;
                end
            end
        endcase
    end
end

assign count = (state == COUNTING) ? count_out : 4'bx;

endmodule