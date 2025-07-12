module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output         valid_out,
    output [15:0]  data_out
);

    // State encoding
    typedef enum logic [0:0] {
        IDLE = 1'b0,
        WAIT = 1'b1
    } state_t;

    state_t       state, next_state;
    reg [7:0]     data_lock;
    reg           valid_out_reg;
    reg [15:0]    data_out_reg;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            data_lock     <= 8'd0;
            data_out_reg  <= 16'd0;
            valid_out_reg <= 1'b0;
        end else begin
            state         <= next_state;

            // Default deassert output valid
            valid_out_reg <= 1'b0;

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in;
                    end
                end
                WAIT: begin
                    if (valid_in) begin
                        data_out_reg  <= {data_lock, data_in};
                        valid_out_reg <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT;
            end
            WAIT: begin
                if (valid_in)
                    next_state = IDLE;
            end
        endcase
    end

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

endmodule