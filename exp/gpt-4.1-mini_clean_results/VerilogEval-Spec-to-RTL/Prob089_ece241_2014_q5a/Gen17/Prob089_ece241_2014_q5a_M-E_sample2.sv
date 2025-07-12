module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam IDLE   = 2'b00;
    localparam COPY   = 2'b01;
    localparam INVERT = 2'b10;

    reg [1:0] state, next_state;
    reg x_reg;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            x_reg <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
            case (state)
                IDLE:      z <= 1'b0;
                COPY:      z <= x_reg;
                INVERT:    z <= ~x_reg;
                default:   z <= 1'b0;
            endcase
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            IDLE: begin
                // When reset is released, start processing input bits
                next_state = COPY;
            end

            COPY: begin
                if (x_reg == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            end

            INVERT: begin
                next_state = INVERT; // stay in INVERT state
            end

            default: next_state = IDLE;
        endcase
    end

endmodule