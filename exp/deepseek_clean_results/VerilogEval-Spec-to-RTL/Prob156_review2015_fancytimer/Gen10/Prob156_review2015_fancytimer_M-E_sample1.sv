module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam IDLE      = 0;
    localparam CAPTURE   = 1;
    localparam RUNNING   = 2;

    reg [1:0] state;
    reg [3:0] pattern_history;
    reg [3:0] delay_reg;
    reg [9:0] fine_counter;  // Counts 0-999
    reg [3:0] coarse_counter; // Counts delay periods
    reg [1:0] capture_counter;

    // Parallel pattern detection
    wire pattern_found = (pattern_history == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_history <= 4'b0;
            delay_reg <= 4'b0;
            fine_counter <= 10'b0;
            coarse_counter <= 4'b0;
            capture_counter <= 2'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            // Always shift in new data
            pattern_history <= {pattern_history[2:0], data};

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (pattern_found) begin
                        state <= CAPTURE;
                        capture_counter <= 2'b0;
                    end
                end

                CAPTURE: begin
                    // Shift in delay value MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    capture_counter <= capture_counter + 1;

                    if (capture_counter == 2'b11) begin
                        state <= RUNNING;
                        counting <= 1'b1;
                        fine_counter <= 10'b0;
                        coarse_counter <= delay_reg;
                    end
                end

                RUNNING: begin
                    if (fine_counter == 10'd999) begin
                        fine_counter <= 10'b0;
                        if (coarse_counter == 4'b0) begin
                            state <= IDLE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            coarse_counter <= coarse_counter - 1;
                        end
                    end else begin
                        fine_counter <= fine_counter + 1;
                    end

                    // Update count output
                    count <= coarse_counter;

                    // Handle done acknowledgment
                    if (done && ack) begin
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule