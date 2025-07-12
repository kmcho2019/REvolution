module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State encoding
    localparam WAIT_FIRST  = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, next_state;
    reg [7:0] data_lock;

    // State and registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= WAIT_FIRST;
            data_lock  <= 8'd0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                WAIT_FIRST: begin
                    valid_out <= 1'b0; // no valid output yet
                    if (valid_in) begin
                        data_lock <= data_in; // store first input
                    end
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        data_out  <= {data_lock, data_in};
                        valid_out <= 1'b1; // assert valid on output next cycle
                    end else begin
                        valid_out <= 1'b0; // no output if no second valid input
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
        case(state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    next_state = WAIT_SECOND;
                end
            end

            WAIT_SECOND: begin
                if (valid_in) begin
                    next_state = WAIT_FIRST; // after output, back to wait first input
                end
            end
        endcase
    end

endmodule