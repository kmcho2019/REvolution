module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;  // For detecting 1101
    reg [3:0] duration_reg; // For storing duration bits
    reg [1:0] shift_cnt;    // Counts 0-3 (4 cycles)

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            duration_reg <= 4'b0;
            shift_cnt <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in new data for pattern detection
                    pattern_reg <= {pattern_reg[2:0], data};
                    shift_cnt <= 2'b0;
                    
                    // Check for pattern 1101
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                    end
                end

                SHIFT: begin
                    // Shift in duration bits
                    duration_reg <= {duration_reg[2:0], data};
                    shift_cnt <= shift_cnt + 1;
                    
                    // After exactly 4 shifts, move to COUNT
                    if (shift_cnt == 2'b11) begin
                        state <= COUNT;
                    end
                end

                COUNT: begin
                    // Wait for counter to finish
                    if (done_counting) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Wait for acknowledgement
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                        duration_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule