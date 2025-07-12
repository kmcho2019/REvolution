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

    reg state, next_state;

    reg [7:0] data_lock;

    // Registers to hold output data and valid flag before registering to output ports
    reg       output_valid_next;
    reg [15:0] output_data_next;

    reg       output_valid_d;
    reg [15:0] output_data_d;

    // State machine and input processing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state             <= WAIT_FIRST;
            data_lock         <= 8'd0;
            output_valid_next <= 1'b0;
            output_data_next  <= 16'd0;
        end else begin
            state <= next_state;

            // Clear output_valid_next by default; set only when second byte arrives
            output_valid_next <= 1'b0;

            case (state)
                WAIT_FIRST: begin
                    if (valid_in) begin
                        data_lock <= data_in;
                        next_state <= WAIT_SECOND;
                    end else begin
                        next_state <= WAIT_FIRST;
                    end
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        // Concatenate stored first byte (high 8 bits) and current byte (low 8 bits)
                        output_data_next  <= {data_lock, data_in};
                        output_valid_next <= 1'b1;
                        next_state        <= WAIT_FIRST;
                    end else begin
                        next_state <= WAIT_SECOND;
                    end
                end

                default: next_state <= WAIT_FIRST;
            endcase
        end
    end

    // Output registers: register output_valid_next and output_data_next to valid_out and data_out
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out   <= 1'b0;
            data_out    <= 16'd0;
            output_valid_d <= 1'b0;
            output_data_d  <= 16'd0;
        end else begin
            output_valid_d <= output_valid_next;
            output_data_d  <= output_data_next;

            valid_out <= output_valid_d;
            data_out  <= output_data_d;
        end
    end

endmodule