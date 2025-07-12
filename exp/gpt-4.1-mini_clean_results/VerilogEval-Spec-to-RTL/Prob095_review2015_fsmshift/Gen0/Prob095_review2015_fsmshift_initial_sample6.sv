module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    // State encoding
    localparam IDLE  = 1'b0;
    localparam SHIFT = 1'b1;

    reg state;
    reg [2:0] count; // 3 bits are enough to count to 4

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, go to SHIFT state and start counter
            state <= SHIFT;
            count <= 3'd0;
            shift_ena <= 1'b1;
        end else begin
            case (state)
                SHIFT: begin
                    if (count == 3'd3) begin
                        // After 4 cycles (0 to 3), disable shift_ena and go to IDLE
                        shift_ena <= 1'b0;
                        state <= IDLE;
                    end else begin
                        // Increment count, keep shift_ena enabled
                        count <= count + 1;
                        shift_ena <= 1'b1;
                    end
                end
                IDLE: begin
                    // Remain in IDLE with shift_ena disabled until reset
                    shift_ena <= 1'b0;
                end
                default: begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end
            endcase
        end
    end

endmodule