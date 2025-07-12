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
    reg [3:0] pattern_reg;
    reg [1:0] shift_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_cnt <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in new data
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    // Only check for pattern when we have 4 bits
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_cnt <= 2'b0;
                    end
                end

                SHIFT: begin
                    // Shift in duration bits
                    pattern_reg <= {pattern_reg[2:0], data};
                    shift_cnt <= shift_cnt + 1;
                    
                    // After 4 shifts, move to COUNT
                    if (shift_cnt == 2'b11)
                        state <= COUNT;
                end

                COUNT: begin
                    // Wait for counter to finish
                    if (done_counting)
                        state <= DONE;
                end

                DONE: begin
                    // Wait for acknowledgement
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
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