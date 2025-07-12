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

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;
            end
            WAIT_SECOND: begin
                if (valid_in)
                    next_state = IDLE;
                else
                    next_state = WAIT_SECOND;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update, data locking and output registering
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            data_lock     <= 8'd0;
            data_out_reg  <= 16'd0;
            valid_out_reg <= 1'b0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
        end else begin
            state <= next_state;

            valid_out_reg <= 1'b0; // Default clear output valid signal each cycle

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in;     // Store first input
                    end
                    // No output generated in IDLE state
                end
                WAIT_SECOND: begin
                    if (valid_in) begin
                        // Concatenate stored and current input to form output
                        data_out_reg  <= {data_lock, data_in};
                        valid_out_reg <= 1'b1;    // Assert valid_out next cycle
                    end
                end
                default: begin
                    // Defensive: do nothing
                end
            endcase

            // Update outputs from registered signals (with one cycle delay after second input)
            valid_out <= valid_out_reg;
            data_out  <= data_out_reg;
        end
    end

endmodule