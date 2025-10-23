module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam FULL = 1'b1;

    reg state;
    reg [7:0] data_lock;          // Stores first 8-bit data
    reg [15:0] data_combined;     // Holds concatenated 16-bit data for output
    reg valid_out_next;           // Valid signal for next cycle output

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers and outputs
            state          <= IDLE;
            data_lock      <= 8'd0;
            data_combined  <= 16'd0;
            valid_out      <= 1'b0;
            valid_out_next <= 1'b0;
            data_out       <= 16'd0;
        end else begin
            // Default de-assert valid_out, it will be set to 1 only for one cycle after second byte arrival
            valid_out <= valid_out_next;
            valid_out_next <= 1'b0; // clear for next cycle unless set below

            // Update data_out only when valid_out asserted
            if (valid_out_next)
                data_out <= data_combined;
            else if (!valid_out)
                data_out <= 16'd0; // Clear when output not valid (optional, to avoid stale data)

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        // Store first byte and move to FULL state
                        data_lock <= data_in;
                        state <= FULL;
                    end
                end
                FULL: begin
                    if (valid_in) begin
                        // Second valid input, prepare concatenated output for next cycle
                        data_combined  <= {data_lock, data_in}; // first byte high, second low
                        valid_out_next <= 1'b1;                  // output valid next cycle
                        state <= IDLE;                           // go back to IDLE for next pair
                    end
                    // If no valid_in, stay in FULL, wait for next byte
                end
            endcase
        end
    end

endmodule