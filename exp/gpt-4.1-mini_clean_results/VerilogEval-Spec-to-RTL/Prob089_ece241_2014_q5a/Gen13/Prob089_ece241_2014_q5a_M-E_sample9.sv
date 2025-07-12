module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding using one-hot style (2 bits):
    localparam IDLE  = 2'b01;
    localparam COPY  = 2'b10;
    localparam INVERT = 2'b11; // Use 2'b11 as a separate state (both bits set)

    reg [1:0] state, next_state;
    reg x_reg;

    // Next state logic based on current state and registered input
    always @(*) begin
        case (state)
            IDLE: 
                // When reset de-asserted, move to COPY
                next_state = COPY;
            COPY:
                // Wait for first '1', then go to INVERT
                if (x_reg == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            INVERT:
                // Stay in INVERT until reset
                next_state = INVERT;
            default:
                // Should not happen, default to IDLE
                next_state = IDLE;
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
        end
    end

    // Moore output depends only on current state and registered input
    // IDLE: output 0
    // COPY: output input bit as-is
    // INVERT: output inverted input bit
    assign z = (state == IDLE) ? 1'b0 :
               (state == COPY) ? x_reg :
               ~x_reg;

endmodule