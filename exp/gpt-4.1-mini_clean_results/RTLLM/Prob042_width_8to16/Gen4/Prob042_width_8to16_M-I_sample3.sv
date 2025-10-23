module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State encoding
    localparam WAIT_FIRST  = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state;
    reg [7:0] data_lock;

    reg next_state;
    reg       output_valid_next;
    reg [15:0] output_data_next;

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default assignments
        next_state        = state;
        output_valid_next = 1'b0;
        output_data_next  = 16'd0;

        case(state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    // Store first byte, wait for second
                    next_state = WAIT_SECOND;
                    output_valid_next = 1'b0; // no output yet
                end
            end

            WAIT_SECOND: begin
                if (valid_in) begin
                    // Concatenate stored first byte and second byte
                    output_data_next  = {data_lock, data_in};
                    output_valid_next = 1'b1; // output valid next cycle
                    next_state = WAIT_FIRST;
                end
            end

            default: next_state = WAIT_FIRST;
        endcase
    end

    // Sequential logic: state and data_lock update, outputs register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= WAIT_FIRST;
            data_lock  <= 8'd0;
            valid_out  <= 1'b0;
            data_out   <= 16'd0;
        end else begin
            state <= next_state;

            case(state)
                WAIT_FIRST: begin
                    if (valid_in) begin
                        data_lock <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    // data_lock holds first byte, no update needed here
                end
            endcase

            // Register output signals
            valid_out <= output_valid_next;
            data_out  <= output_data_next;
        end
    end

endmodule