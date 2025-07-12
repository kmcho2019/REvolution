module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Combined shift-state register
    // [10]: state (1=IDLE, 0=ACTIVE)
    // [9:1]: shift reg (includes start and stop bits)
    // [0]: early stop flag
    reg [10:0] shift_state;

    // Constants for positions
    localparam START_BIT_POS = 9;
    localparam STOP_BIT_POS = 1;
    localparam DATA_MSB_POS = 2;

    always @(posedge clk) begin
        if (reset) begin
            shift_state <= 11'b1_000000000; // IDLE state
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;
            
            if (shift_state[10]) begin // IDLE state
                if (in == 0) begin // Start bit detected
                    shift_state <= {1'b0, 9'b000000000, 1'b0}; // ACTIVE state
                end
            end else begin // ACTIVE state
                // Shift in new bit and check conditions
                shift_state <= {1'b0, in, shift_state[9:1]};
                
                // Early stop bit detection
                if (shift_state[0] & in) begin
                    shift_state[10] <= 1'b1; // Return to IDLE
                    out_byte <= shift_state[DATA_MSB_POS +: 8]; // Extract data
                    done <= 1;
                end
                
                // Check for complete frame
                if (shift_state[STOP_BIT_POS] == 1'b1 && 
                    shift_state[START_BIT_POS] == 1'b0) begin
                    shift_state[0] <= 1'b1; // Mark valid stop
                end
            end
        end
    end

endmodule