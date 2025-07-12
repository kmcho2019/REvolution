module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [0:0] {
        IDLE = 1'b0,
        WAIT = 1'b1
    } state_t;

    state_t       current_state, next_state;
    reg [7:0]     first_byte;
    reg           output_enable;
    reg [15:0]    output_reg;

    // State transition and input capture
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            first_byte    <= 8'd0;
            output_enable <= 1'b0;
            output_reg    <= 16'd0;
        end else begin
            current_state <= next_state;

            output_enable <= 1'b0; // Default no output enable

            case (current_state)
                IDLE: begin
                    if (valid_in) begin
                        first_byte <= data_in;
                        // Wait for next byte
                    end
                end
                WAIT: begin
                    if (valid_in) begin
                        output_reg    <= {first_byte, data_in};
                        output_enable <= 1'b1; // Output valid next cycle
                    end
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (current_state)
            IDLE: 
                next_state = valid_in ? WAIT : IDLE;
            WAIT:
                next_state = valid_in ? IDLE : WAIT;
            default: next_state = IDLE;
        endcase
    end

    // Output register and valid signal registered one cycle after output_enable asserted
    reg valid_out_d;
    reg [15:0] data_out_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out  <= 16'd0;
            valid_out_d <= 1'b0;
            data_out_d  <= 16'd0;
        end else begin
            valid_out_d <= output_enable;
            data_out_d  <= output_reg;

            valid_out <= valid_out_d;
            data_out  <= data_out_d;
        end
    end

endmodule