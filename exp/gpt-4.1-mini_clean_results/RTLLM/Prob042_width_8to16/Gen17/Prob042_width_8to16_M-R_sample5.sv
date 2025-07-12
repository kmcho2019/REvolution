module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State definitions (binary encoding)
    localparam IDLE = 1'b0;
    localparam WAIT = 1'b1;

    reg state;
    reg [7:0] first_byte;

    // Registers for output pipeline stage (to delay valid and data_out by one cycle)
    reg       valid_out_reg;
    reg [15:0] data_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            first_byte    <= 8'd0;
            valid_out_reg <= 1'b0;
            data_out_reg  <= 16'd0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
        end else begin
            // Default output valid disable
            valid_out_reg <= 1'b0;

            case(state)
                IDLE: begin
                    if (valid_in) begin
                        // Store first byte, go to WAIT state
                        first_byte <= data_in;
                        state      <= WAIT;
                    end
                end

                WAIT: begin
                    if (valid_in) begin
                        // Concatenate first_byte and current data_in (first_byte in high bits)
                        data_out_reg  <= {first_byte, data_in};
                        valid_out_reg <= 1'b1; // Will assert valid_out next cycle
                        state         <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase

            // Output valid and data_out delayed by one cycle
            valid_out <= valid_out_reg;
            data_out  <= data_out_reg;
        end
    end

endmodule