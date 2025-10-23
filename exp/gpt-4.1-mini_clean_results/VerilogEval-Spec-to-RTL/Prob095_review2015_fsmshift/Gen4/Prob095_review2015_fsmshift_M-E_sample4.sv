module TopModule (
    input  wire clk,
    input  wire reset,    // Active high synchronous reset
    output reg  shift_ena
);

    // FSM state encoding
    localparam IDLE   = 1'b0;
    localparam ENABLE = 1'b1;

    reg state;
    reg [2:0] cycle_count;  // Counts from 0 to 3 for 4 cycles

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, enter ENABLE state and start counting
            state       <= ENABLE;
            cycle_count <= 3'd0;
            shift_ena   <= 1'b1;
        end else begin
            case (state)
                ENABLE: begin
                    if (cycle_count == 3'd3) begin
                        // After 4 cycles (0 to 3), go to IDLE
                        state     <= IDLE;
                        shift_ena <= 1'b0;
                    end else begin
                        // Keep enabling shift and increment cycle count
                        cycle_count <= cycle_count + 3'd1;
                        shift_ena   <= 1'b1;
                    end
                end

                IDLE: begin
                    // Remain in IDLE with shift_ena deasserted
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule