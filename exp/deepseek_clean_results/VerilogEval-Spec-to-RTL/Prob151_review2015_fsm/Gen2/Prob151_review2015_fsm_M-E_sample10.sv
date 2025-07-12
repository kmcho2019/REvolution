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

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam SHIFT = 4'b0010;
    localparam COUNT = 4'b0100;
    localparam DONE  = 4'b1000;

    reg [3:0] state;
    reg [3:0] pattern_reg;  // Full pattern register
    reg [2:0] shift_counter;

    // Pattern register update
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Shift counter update
    always @(posedge clk) begin
        if (reset || state == IDLE) begin
            shift_counter <= 3'b0;
        end else if (state == SHIFT) begin
            shift_counter <= shift_counter + 1;
        end
    end

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT;
                    end
                end
                SHIFT: begin
                    if (shift_counter == 3'b011) begin  // After 4 cycles (0-3)
                        state <= COUNT;
                    end
                end
                COUNT: begin
                    if (done_counting) begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Output logic (Moore style)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule