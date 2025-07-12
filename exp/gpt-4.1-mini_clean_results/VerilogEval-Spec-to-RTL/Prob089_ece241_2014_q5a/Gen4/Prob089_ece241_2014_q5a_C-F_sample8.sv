module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam COPY   = 1'b0;
    localparam INVERT = 1'b1;

    reg state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            COPY:   next_state = (x == 1'b1) ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // Sequential logic: state and output registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            z <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                COPY:   z <= x;      // Output input bit until first '1'
                INVERT: z <= ~x;     // Output inverted bits after first '1'
            endcase
        end
    end

endmodule