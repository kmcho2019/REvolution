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
    localparam IDLE  = 1'b0;
    localparam ACTIVE = 1'b1;

    reg state;
    reg [3:0] pattern_reg;  // Stores both pattern and shift data
    reg [1:0] phase_counter; // Tracks shift and counting phases
    reg done_counting_prev; // For edge detection

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            phase_counter <= 2'b0;
            done_counting_prev <= 1'b0;
        end else begin
            done_counting_prev <= done_counting;
            
            case (state)
                IDLE: begin
                    // Shift in data and check for pattern 1101
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= ACTIVE;
                        phase_counter <= 2'b0;
                    end
                end

                ACTIVE: begin
                    if (phase_counter < 2'b11) begin
                        // Shift phase
                        pattern_reg <= {pattern_reg[2:0], data};
                        phase_counter <= phase_counter + 1;
                    end else if (!done_counting_prev && done_counting) begin
                        // Counting done - move to done state
                        state <= IDLE; // Implicit done state
                    end
                end
            endcase
        end
    end

    // Output logic
    assign shift_ena = (state == ACTIVE) && (phase_counter < 2'b11);
    assign counting = (state == ACTIVE) && (phase_counter == 2'b11) && !done_counting;
    assign done = (state == ACTIVE) && (phase_counter == 2'b11) && done_counting && !ack;

    // Lazy reset implementation
    always @(posedge clk) begin
        if (done && ack) begin
            state <= IDLE;
        end
    end

endmodule