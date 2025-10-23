module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding
    localparam COPY   = 1'b0;  // Before first '1' detected; output input bits directly
    localparam INVERT = 1'b1;  // After first '1'; output inverted bits

    reg state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            COPY:   next_state = (x == 1'b1) ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // Sequential logic: state and Moore output with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            z <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                COPY:   z <= x;       // Output input bit until first '1'
                INVERT: z <= ~x;      // Output inverted bits thereafter
            endcase
        end
    end

endmodule