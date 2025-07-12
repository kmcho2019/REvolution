module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding (one-hot)
    localparam IDLE   = 3'b001;
    localparam COPY   = 3'b010;
    localparam INVERT = 3'b100;

    reg [2:0] state, next_state;
    reg x_reg;      // Registered input bit

    // State and input register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            x_reg <= 1'b0;
            z     <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
            // Moore output registered: depends on current state and registered input
            case (next_state)
                IDLE:   z <= 1'b0;           // No valid output during reset
                COPY:   z <= x_reg;          // Output input bit directly
                INVERT: z <= ~x_reg;         // Output inverted bit
                default: z <= 1'b0;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // After reset release, move to COPY state immediately
                next_state = COPY;
            end
            COPY: begin
                // Wait for first '1' bit (x_reg) to switch to INVERT state
                if (x_reg == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            end
            INVERT: begin
                // Stay in INVERT state indefinitely (processing remaining bits)
                next_state = INVERT;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule