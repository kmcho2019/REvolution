module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // States
    localparam COPY   = 1'b0;
    localparam INVERT = 1'b1;

    reg state, next_state;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            COPY: begin
                if (x == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            end
            INVERT: begin
                next_state = INVERT;
            end
            default: next_state = COPY;
        endcase
    end

    // Output logic (Moore output)
    always @(*) begin
        case(state)
            COPY:   z = x;
            INVERT: z = ~x;
            default:z = 1'b0;
        endcase
    end

endmodule