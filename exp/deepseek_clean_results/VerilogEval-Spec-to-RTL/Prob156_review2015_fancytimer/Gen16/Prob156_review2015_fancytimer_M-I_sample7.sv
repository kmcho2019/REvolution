module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam IDLE     = 2'b00;
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_shift;
    reg [1:0] bit_counter;
    reg [13:0] cycle_counter;  // 14-bit counter for up to 15000 cycles
    reg [13:0] total_cycles;   // Stores (delay+1)*1000

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_shift <= 4'b0;
            bit_counter <= 2'b0;
            cycle_counter <= 14'b0;
            total_cycles <= 14'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    if (done) begin
                        if (ack) done <= 1'b0;
                    end else begin
                        pattern_reg <= {pattern_reg[2:0], data};
                        if (pattern_reg == 4'b1101) begin
                            state <= CAPTURE;
                            bit_counter <= 2'b0;
                            pattern_reg <= 4'b0; // Clear after detection
                        end
                    end
                end

                CAPTURE: begin
                    delay_shift <= {delay_shift[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 2'b11) begin
                        state <= COUNTING;
                        counting <= 1'b1;
                        total_cycles <= (delay_shift + 1) * 14'd1000;
                        cycle_counter <= (delay_shift + 1) * 14'd1000 - 1;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 0) begin
                        state <= IDLE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter - 1;
                        // Update count output (remaining chunks - 1)
                        count <= (cycle_counter / 14'd1000);
                    end
                end
            endcase
        end
    end

endmodule