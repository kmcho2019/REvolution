module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        WAIT_SECOND = 2'd1,
        OUTPUT_VALID = 2'd2
    } state_t;

    state_t state, next_state;

    reg [7:0] data_first;      // Stores first 8-bit data
    reg [7:0] data_second;     // Stores second 8-bit data

    // State transition logic (combinational)
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;
            end
            WAIT_SECOND: begin
                if (valid_in)
                    next_state = OUTPUT_VALID;
                else
                    next_state = WAIT_SECOND;
            end
            OUTPUT_VALID: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update, data storage, and outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_first <= 8'd0;
            data_second <= 8'd0;
            data_out <= 16'd0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            valid_out <= 1'b0;  // default no valid output

            case(state)
                IDLE: begin
                    if (valid_in) begin
                        data_first <= data_in;  // Store first input
                    end
                end
                WAIT_SECOND: begin
                    if (valid_in) begin
                        data_second <= data_in; // Store second input
                    end
                end
                OUTPUT_VALID: begin
                    data_out <= {data_first, data_second}; // Concatenate and output
                    valid_out <= 1'b1; // Output valid one cycle after second input
                end
            endcase
        end
    end

endmodule