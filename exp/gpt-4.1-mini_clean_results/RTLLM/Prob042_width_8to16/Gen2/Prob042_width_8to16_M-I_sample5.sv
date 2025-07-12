module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State encoding using localparam for synthesis compatibility
    localparam WAIT_FIRST  = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, next_state;
    reg [7:0] first_byte;

    // FSM sequential logic with synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            state     <= WAIT_FIRST;
            first_byte <= 8'b0;
            valid_out <= 1'b0;
            data_out  <= 16'b0;
        end else begin
            state <= next_state;

            case (state)
                WAIT_FIRST: begin
                    valid_out <= 1'b0; // no output on first byte arrival
                    if (valid_in) begin
                        first_byte <= data_in; // latch first byte
                    end
                    // data_out holds previous value, no change
                end
                WAIT_SECOND: begin
                    if (valid_in) begin
                        data_out  <= {first_byte, data_in}; // concat first and second byte
                        valid_out <= 1'b1;                   // output valid next clock cycle
                    end else begin
                        valid_out <= 1'b0; // no new data output if no valid_in
                        // data_out holds previous value
                    end
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            WAIT_FIRST: begin
                if (valid_in) 
                    next_state = WAIT_SECOND;
                else
                    next_state = WAIT_FIRST;
            end
            WAIT_SECOND: begin
                if (valid_in)
                    next_state = WAIT_FIRST;
                else
                    next_state = WAIT_SECOND;
            end
            default: next_state = WAIT_FIRST;
        endcase
    end

endmodule