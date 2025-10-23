module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output          valid_out,
    output [15:0]   data_out
);

    // FSM states
    typedef enum logic [0:0] {
        IDLE        = 1'b0,
        WAIT_SECOND = 1'b1
    } state_t;

    state_t state, next_state;

    reg [7:0] first_byte;
    reg [15:0] output_reg;
    reg valid_out_reg;

    // FSM state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM next state logic and outputs
    always @(*) begin
        // Default assignments
        next_state = state;
        valid_out_reg = 1'b0;

        case (state)
            IDLE: begin
                if (valid_in) begin
                    next_state = WAIT_SECOND;
                end
            end
            WAIT_SECOND: begin
                if (valid_in) begin
                    // When second valid input arrives, assert output next cycle
                    valid_out_reg = 1'b1;
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Data registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte    <= 8'd0;
            output_reg    <= 16'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        first_byte <= data_in; // store first byte
                    end
                end
                WAIT_SECOND: begin
                    if (valid_in) begin
                        // concatenate first and second bytes and update output_reg
                        output_reg <= {first_byte, data_in};
                    end
                end
            endcase
        end
    end

    // Output registers to register valid_out one cycle after second byte
    reg valid_out_d;
    reg [15:0] data_out_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out_d <= 1'b0;
            data_out_d  <= 16'd0;
        end else begin
            valid_out_d <= valid_out_reg;
            if (valid_out_reg)
                data_out_d <= output_reg;
        end
    end

    assign valid_out = valid_out_d;
    assign data_out  = data_out_d;

endmodule