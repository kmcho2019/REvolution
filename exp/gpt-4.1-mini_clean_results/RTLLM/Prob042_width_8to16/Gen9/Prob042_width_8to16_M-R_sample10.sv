module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [1:0] {
        WAIT_FIRST  = 2'b00,
        WAIT_SECOND = 2'b01
    } state_t;

    state_t state, next_state;

    reg [7:0] first_byte;
    reg [7:0] second_byte;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= WAIT_FIRST;
            first_byte  <= 8'd0;
            second_byte <= 8'd0;
            data_out    <= 16'd0;
            valid_out   <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                WAIT_FIRST: begin
                    valid_out <= 1'b0;
                    if (valid_in) begin
                        first_byte <= data_in;
                    end
                end
                WAIT_SECOND: begin
                    valid_out <= 1'b1;
                    data_out  <= {first_byte, second_byte};
                end
                default: begin
                    valid_out <= 1'b0;
                    data_out  <= 16'd0;
                end
            endcase
        end
    end

    // Next state logic and data capture
    always @(*) begin
        next_state = state;
        second_byte = 8'd0;

        case (state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    next_state = WAIT_SECOND;
                    // second_byte captured with second valid_in; need to store now
                    // To keep synchronous capture, second_byte must be registered on posedge clk in WAIT_SECOND state
                    // but combinational logic cannot assign register here; use logic inside clk always block
                    // So move second_byte capture to clk always block below.
                end
            end
            WAIT_SECOND: begin
                if (valid_in) begin
                    next_state = WAIT_SECOND; // hold here until output produced in clk block
                end else begin
                    next_state = WAIT_FIRST;
                end
            end
        endcase
    end

    // Capture second_byte on the rising edge, after detecting transition to WAIT_SECOND
    // Since combinational next_state logic cannot assign registers, capture second_byte inside clk always block below:
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            second_byte <= 8'd0;
        end else begin
            if (state == WAIT_FIRST && valid_in) begin
                // Upon detecting second valid_in which triggers WAIT_SECOND state
                second_byte <= data_in;
            end
            // else second_byte remains unchanged until reset or next capture
        end
    end

endmodule