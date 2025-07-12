module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // One-hot encoded states
    localparam [3:0] 
        IDLE   = 4'b0001,
        SHIFT  = 4'b0010,
        COUNT  = 4'b0100,
        NOTIFY = 4'b1000;

    reg [3:0] state, next_state;
    reg [1:0] shift_counter;
    reg [3:0] pattern_reg;

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Shift counter for 4-cycle control
    always @(posedge clk) begin
        if (reset || state != SHIFT) begin
            shift_counter <= 2'b0;
        end else begin
            shift_counter <= shift_counter + 1;
        end
    end

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (pattern_reg == 4'b1101) ? SHIFT : IDLE;
            end
            SHIFT: begin
                next_state = (shift_counter == 2'b11) ? COUNT : SHIFT;
            end
            COUNT: begin
                next_state = done_counting ? NOTIFY : COUNT;
            end
            NOTIFY: begin
                next_state = ack ? IDLE : NOTIFY;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Registered output logic
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            shift_ena <= (state == SHIFT);
            counting <= (state == COUNT);
            done <= (state == NOTIFY);
        end
    end

endmodule