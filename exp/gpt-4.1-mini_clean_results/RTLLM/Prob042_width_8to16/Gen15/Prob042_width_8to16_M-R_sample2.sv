module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output         valid_out,
    output [15:0]  data_out
);

    // State encoding
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg        state, next_state;
    reg [7:0]  first_data;
    reg        valid_out_reg;
    reg [15:0] data_out_reg;

    // Sequential: State and output registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            first_data    <= 8'd0;
            valid_out_reg <= 1'b0;
            data_out_reg  <= 16'd0;
        end else begin
            state <= next_state;

            // By default, clear output valid flag
            valid_out_reg <= 1'b0;

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        first_data <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        data_out_reg  <= {first_data, data_in};
                        valid_out_reg <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Combinational: Next state logic
    always @(*) begin
        case (state)
            IDLE:
                if (valid_in)
                    next_state = WAIT_SECOND;
                else
                    next_state = IDLE;

            WAIT_SECOND:
                if (valid_in)
                    next_state = IDLE;
                else
                    next_state = WAIT_SECOND;

            default: next_state = IDLE;
        endcase
    end

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

endmodule