module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam STATE_A = 2'b00;  // Initial/reset state
localparam STATE_B = 2'b01;  // Pulse f state
localparam STATE_C = 2'b10;  // Monitor for 101 pattern
localparam STATE_D = 2'b11;  // Monitor y with timeout

reg [1:0] state;
reg [1:0] x_pipe;  // 2-stage pipeline for pattern detection
reg x_latest;       // Most recent x value
reg [1:0] timeout;  // 2-bit counter for y monitoring

// Pattern detection wire (checks for 1-0-1 in pipeline)
wire pattern_match = (x_pipe == 2'b01) && (x_latest == 1'b1);

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 1'b0;
        g <= 1'b0;
        x_pipe <= 2'b0;
        x_latest <= 1'b0;
        timeout <= 2'b0;
    end
    else begin
        // Update x pipeline for pattern detection
        x_latest <= x;
        x_pipe <= {x_pipe[0], x_latest};

        case (state)
            STATE_A: begin
                // Initial state - wait for reset release
                f <= 1'b0;
                g <= 1'b0;
                state <= STATE_B;
            end

            STATE_B: begin
                // Pulse f for one cycle
                f <= 1'b1;
                state <= STATE_C;
            end

            STATE_C: begin
                // Monitor for 101 pattern
                f <= 1'b0;
                if (pattern_match) begin
                    g <= 1'b1;
                    state <= STATE_D;
                    timeout <= 2'b10;  // Initialize 2-cycle timeout
                end
            end

            STATE_D: begin
                // Monitor y with 2-cycle timeout
                if (y) begin
                    // Maintain g=1 permanently
                    state <= STATE_D;
                end
                else if (timeout == 2'b00) begin
                    // Timeout expired - set g=0 permanently
                    g <= 1'b0;
                    state <= STATE_D;
                end
                else begin
                    // Decrement timeout counter
                    timeout <= timeout - 1;
                end
            end
        endcase
    end
end

endmodule