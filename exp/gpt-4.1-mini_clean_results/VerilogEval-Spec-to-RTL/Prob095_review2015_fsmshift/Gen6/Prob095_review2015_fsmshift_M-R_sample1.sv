module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

    // State encoding
    typedef enum logic [0:0] {
        ENABLE  = 1'b0,
        DISABLE = 1'b1
    } state_t;

    state_t state, next_state;
    reg [2:0] count, next_count;

    // State and counter sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            count <= 3'd0;
        end else begin
            state <= next_state;
            count <= next_count;
        end
    end

    // Next state and count logic
    always @(*) begin
        case (state)
            ENABLE: begin
                if (count == 3'd3) begin
                    next_state = DISABLE;
                    next_count = count; // hold count at 3 after done
                end else begin
                    next_state = ENABLE;
                    next_count = count + 1;
                end
            end
            DISABLE: begin
                next_state = DISABLE;
                next_count = count;
            end
            default: begin
                next_state = ENABLE;
                next_count = 3'd0;
            end
        endcase
    end

    // Output logic: shift_ena is high in ENABLE state, low otherwise
    assign shift_ena = (state == ENABLE);

endmodule