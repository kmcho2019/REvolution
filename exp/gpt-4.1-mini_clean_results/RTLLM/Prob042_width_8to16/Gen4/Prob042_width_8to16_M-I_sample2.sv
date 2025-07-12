module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    // State encoding
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg        state;
    reg [7:0]  data_lock;       // Store first 8-bit data

    reg [15:0] data_out_next;   // Latched concatenated data
    reg        valid_out_next;  // Output valid for next cycle

    // Sequential logic: state machine, data latching, and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= IDLE;
            data_lock      <= 8'd0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
            data_out_next  <= 16'd0;
            valid_out_next <= 1'b0;
        end else begin
            // Default output update (1-cycle delay)
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            // Clear next cycle outputs by default
            valid_out_next <= 1'b0;

            case(state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in;
                        state     <= WAIT_SECOND;
                    end
                    // else remain in IDLE
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        // Concatenate stored data (high 8 bits) and current data (low 8 bits)
                        data_out_next  <= {data_lock, data_in};
                        valid_out_next <= 1'b1;
                        state          <= IDLE; // Return to IDLE after outputting
                    end
                    // else remain in WAIT_SECOND until next valid_in
                end

                default: begin
                    state <= IDLE; // Safety fallback
                end
            endcase
        end
    end

endmodule