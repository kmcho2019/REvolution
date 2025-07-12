module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State encoding
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, next_state;

    reg [7:0]  data_lock;       // Store first 8-bit input
    reg [15:0] data_out_reg;    // Registered 16-bit output data
    reg        valid_out_reg;   // Registered output valid flag

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock      <= 8'd0;
            data_out_reg   <= 16'd0;
            valid_out_reg  <= 1'b0;
            valid_out      <= 1'b0;
            data_out       <= 16'd0;
        end else begin
            valid_out_reg <= 1'b0; // Default clear valid_out_reg each cycle

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in; // Store first input
                        next_state <= WAIT_SECOND;
                    end else begin
                        next_state <= IDLE;
                    end
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        data_out_reg  <= {data_lock, data_in}; // Concatenate stored + new input
                        valid_out_reg <= 1'b1;                  // Assert valid_out next cycle
                        next_state    <= IDLE;                   // Go back to IDLE for next pair
                    end else begin
                        next_state <= WAIT_SECOND;
                    end
                end

                default: begin
                    next_state <= IDLE;
                end
            endcase

            // Update outputs from registered signals
            valid_out <= valid_out_reg;
            data_out  <= data_out_reg;
        end
    end

endmodule