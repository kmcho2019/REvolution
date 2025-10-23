module width_8to16 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [7:0]  data_in,
    output reg         valid_out,
    output reg  [15:0] data_out
);

    typedef enum logic [1:0] {
        IDLE        = 2'b00,
        WAIT_SECOND = 2'b01,
        OUTPUT      = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0] first_data;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            first_data <= 8'd0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    valid_out <= 1'b0;
                    if (valid_in) begin
                        first_data <= data_in; // Store first input
                    end
                end
                WAIT_SECOND: begin
                    valid_out <= 1'b0;
                    // first_data already stored
                end
                OUTPUT: begin
                    // Output valid one cycle after second input
                    valid_out <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic and output data update
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (valid_in) 
                    next_state = WAIT_SECOND;
            end
            WAIT_SECOND: begin
                if (valid_in) 
                    next_state = OUTPUT;
            end
            OUTPUT: begin
                next_state = IDLE;
            end
        endcase
    end

    // Update data_out in OUTPUT state (one cycle after second input)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 16'd0;
        end else if (state == WAIT_SECOND && valid_in) begin
            // Capture concatenated data on second valid input, but do not assert valid_out yet
            data_out <= {first_data, data_in};
        end
    end

endmodule