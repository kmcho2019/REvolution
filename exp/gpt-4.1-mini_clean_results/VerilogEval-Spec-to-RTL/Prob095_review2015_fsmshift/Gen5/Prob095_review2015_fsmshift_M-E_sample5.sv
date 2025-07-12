module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    // State encoding
    localparam IDLE   = 1'b0;
    localparam ENABLE = 1'b1;

    reg state, next_state;
    reg [2:0] enable_count; // count from 4 down to 1

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            enable_count <= 3'd4; // start 4 cycle count on reset
        end else begin
            state <= next_state;
            // Manage enable_count only in ENABLE state
            if (state == ENABLE) begin
                if (enable_count > 1)
                    enable_count <= enable_count - 1;
                else
                    enable_count <= 0;
            end else begin
                enable_count <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = IDLE;        // stay idle forever unless extended later
            ENABLE:  next_state = (enable_count == 1) ? IDLE : ENABLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1; // enabled during reset cycle and following 3 cycles
        end else begin
            shift_ena <= (state == ENABLE);
        end
    end

endmodule