module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire pattern_detected,  // Added input for pattern detection
    output reg  shift_ena
);

    // FSM states
    localparam IDLE       = 1'b0;
    localparam SHIFT_ENA  = 1'b1;

    reg state;
    reg [2:0] cycle_count;  // Count cycles while shift_ena is asserted

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, start enable period
            state <= SHIFT_ENA;
            cycle_count <= 3'd0;
            shift_ena <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    shift_ena <= 1'b0;
                    if (pattern_detected) begin
                        state <= SHIFT_ENA;
                        cycle_count <= 3'd0;
                        shift_ena <= 1'b1;
                    end
                end

                SHIFT_ENA: begin
                    shift_ena <= 1'b1;
                    if (cycle_count == 3'd3) begin
                        // Completed 4 cycles (0 to 3)
                        state <= IDLE;
                        shift_ena <= 1'b0;
                    end
                    cycle_count <= cycle_count + 1;
                end
            endcase
        end
    end

endmodule