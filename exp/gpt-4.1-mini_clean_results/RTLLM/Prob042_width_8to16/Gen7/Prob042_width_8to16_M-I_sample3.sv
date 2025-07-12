module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State encoding
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, next_state;

    reg [7:0]  first_byte;
    reg [15:0] concat_data;       // holds concatenated data at second input
    reg        output_valid_reg;  // indicates valid_out should be asserted next cycle

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
            end
            WAIT_SECOND: begin
                if (valid_in)
                    next_state = IDLE;
            end
        endcase
    end

    // Data capture and output generation logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte       <= 8'd0;
            concat_data      <= 16'd0;
            output_valid_reg <= 1'b0;
            valid_out        <= 1'b0;
            data_out         <= 16'd0;
        end else begin
            valid_out <= output_valid_reg;  // output valid delayed one cycle
            data_out  <= concat_data;       // output data delayed one cycle
            output_valid_reg <= 1'b0;       // default, cleared each cycle

            case(state)
                IDLE: begin
                    if (valid_in) begin
                        first_byte <= data_in;  // store first byte
                    end
                end
                WAIT_SECOND: begin
                    if (valid_in) begin
                        // Concatenate first_byte (high 8 bits) with new data_in (low 8 bits)
                        concat_data      <= {first_byte, data_in};
                        output_valid_reg <= 1'b1; // output valid asserted next cycle
                    end
                end
            endcase
        end
    end

endmodule