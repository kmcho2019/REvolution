module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding: 2 bits for clarity
    localparam IDLE   = 2'b00; // Before reset release
    localparam PASS   = 2'b01; // Output input bits as is (before first '1')
    localparam INVERT = 2'b10; // Output inverted bits (after first '1')

    reg [1:0] state, next_state;

    reg x_reg; // Registered input bit

    // Register input bit on clock edge or async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
        end
    end

    // FSM state register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Upon reset release, start processing input bits
                // Move to PASS immediately after reset release
                next_state = PASS;
            end
            PASS: begin
                // Remain in PASS until first '1' detected in registered input
                if (x_reg == 1'b1)
                    next_state = INVERT;
                else
                    next_state = PASS;
            end
            INVERT: begin
                // After first '1', remain in INVERT for all subsequent bits
                next_state = INVERT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore): depends only on current state and registered input
    always @(*) begin
        case (state)
            IDLE:   z = 1'b0;
            PASS:   z = x_reg;
            INVERT: z = ~x_reg;
            default: z = 1'b0;
        endcase
    end

endmodule