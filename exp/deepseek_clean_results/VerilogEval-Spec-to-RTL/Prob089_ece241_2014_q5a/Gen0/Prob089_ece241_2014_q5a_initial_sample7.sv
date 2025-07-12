module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Define states
    parameter STATE_COPY = 1'b0;
    parameter STATE_INVERT = 1'b1;
    
    reg state;
    reg next_state;

    // State transition logic
    always @(*) begin
        case (state)
            STATE_COPY:
                next_state = x ? STATE_INVERT : STATE_COPY;
            STATE_INVERT:
                next_state = STATE_INVERT;
            default:
                next_state = STATE_COPY;
        endcase
    end

    // State register and output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_COPY;
            z <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                STATE_COPY: z <= x;
                STATE_INVERT: z <= ~x;
                default: z <= x;
            endcase
        end
    end

endmodule