module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE  = 2'b00,  // Reset asserted or waiting for reset release
        COPY  = 2'b01,  // Copy input bits until first '1' encountered
        INVERT= 2'b10   // Invert bits after first '1'
    } state_t;

    reg [1:0] state, next_state;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) 
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (Moore FSM)
    always @(*) begin
        case (state)
            IDLE: begin
                // When reset is released, start copying bits
                next_state = COPY;
            end
            COPY: begin
                // Stay in COPY until input bit '1' found, then go to INVERT
                if (x == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            end
            INVERT: begin
                // Stay in INVERT until reset
                next_state = INVERT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Moore output logic: output depends on current state and input x
    always @(posedge clk or posedge areset) begin
        if (areset) 
            z <= 1'b0;
        else begin
            case (state)
                IDLE:   z <= 1'b0;      // output zero while in reset
                COPY:   z <= x;         // copy input bit as is
                INVERT: z <= ~x;        // invert input bit
                default:z <= 1'b0;
            endcase
        end
    end

endmodule