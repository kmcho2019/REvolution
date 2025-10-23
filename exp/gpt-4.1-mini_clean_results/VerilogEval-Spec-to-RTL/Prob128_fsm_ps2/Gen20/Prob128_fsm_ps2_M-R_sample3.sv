module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // State encoding
    localparam WAIT_START = 2'b00,
               BYTE_2     = 2'b01,
               BYTE_3     = 2'b10;

    reg [1:0] state, next_state;
    reg       done_reg;

    // done output: registered pulse asserted one cycle after third byte received
    assign done = done_reg;

    // Next state logic combinational
    always @(*) begin
        case (state)
            WAIT_START: 
                if (in[3])
                    next_state = BYTE_2;
                else
                    next_state = WAIT_START;

            BYTE_2:
                next_state = BYTE_3;

            BYTE_3:
                next_state = WAIT_START;

            default:
                next_state = WAIT_START;
        endcase
    end

    // Sequential state and done register update
    always @(posedge clk) begin
        if (reset) begin
            state    <= WAIT_START;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;

            // done pulse is high for one cycle immediately after the third byte
            done_reg <= (state == BYTE_3);
        end
    end

endmodule