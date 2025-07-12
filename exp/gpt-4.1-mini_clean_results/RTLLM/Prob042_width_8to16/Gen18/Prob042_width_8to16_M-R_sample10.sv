module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM state declaration
    localparam IDLE          = 1'b0;
    localparam WAIT_SECOND   = 1'b1;

    reg state, next_state;

    reg [7:0] data_lock;

    // State and output registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            data_lock  <= 8'd0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    valid_out <= 1'b0;
                    if (valid_in) begin
                        data_lock <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    valid_out <= 1'b0; // default low, may set below
                    if (valid_in) begin
                        // Concatenate and output data
                        data_out  <= {data_lock, data_in};
                        valid_out <= 1'b1;
                    end
                end

                default: begin
                    valid_out <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = WAIT_SECOND;
            end

            WAIT_SECOND: begin
                if (valid_in)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule