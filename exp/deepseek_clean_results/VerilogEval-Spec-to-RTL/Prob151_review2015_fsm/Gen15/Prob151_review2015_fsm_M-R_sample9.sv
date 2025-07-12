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
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state, next_state;
    reg [1:0] counter;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: begin
                if ({counter, data} == 3'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                if (counter == 2'b11)
                    next_state = COUNTING;
                else
                    next_state = SHIFT;
            end
            COUNTING: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Counter logic
    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b0;
        end else begin
            case (state)
                IDLE: counter <= {counter[0], data};
                SHIFT: counter <= counter + 1;
                default: counter <= 2'b0;
            endcase
        end
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule