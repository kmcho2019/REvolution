module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam COPY  = 2'b01;
    localparam INVERT = 2'b10;

    reg [1:0] state, next_state;
    reg next_z;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

    // Next state and output logic (Moore: output depends only on state)
    always @(*) begin
        // Default assignments
        next_state = state;
        next_z = 1'b0;

        case (state)
            IDLE: begin
                // Wait for reset release; output zero
                next_state = COPY;
                next_z = 1'b0;
            end
            COPY: begin
                // Output equals input x directly
                next_z = x;
                // On first '1' bit, transition to INVERT
                if (x == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            end
            INVERT: begin
                // Output is inverted input bit
                next_z = ~x;
                // Remain in INVERT state
                next_state = INVERT;
            end
            default: begin
                next_state = IDLE;
                next_z = 1'b0;
            end
        endcase
    end

endmodule