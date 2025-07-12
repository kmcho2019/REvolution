module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // One-hot state encoding
    localparam OFF = 2'b01;
    localparam ON  = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic and output computation
    always @(*) begin
        // Default assignments
        next_state = OFF;
        out = 1'b0;

        case (state)
            OFF: begin
                out = 1'b0;
                if (j)
                    next_state = ON;
                else
                    next_state = OFF;
            end
            ON: begin
                out = 1'b1;
                if (k)
                    next_state = OFF;
                else
                    next_state = ON;
            end
            default: begin
                // Safe default
                next_state = OFF;
                out = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

endmodule