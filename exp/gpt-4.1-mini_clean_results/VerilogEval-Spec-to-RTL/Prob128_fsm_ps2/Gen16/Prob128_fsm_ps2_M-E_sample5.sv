module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // State encoding
    localparam WAIT_START = 2'd0;
    localparam BYTE2      = 2'd1;
    localparam BYTE3      = 2'd2;

    reg [1:0] state, next_state;
    reg       done_reg;

    // Combinational logic for next state and done generation
    always @(*) begin
        done_reg  = 1'b0;
        next_state = state;

        case(state)
            WAIT_START: begin
                if (in[3])       // start byte detected
                    next_state = BYTE2;
            end

            BYTE2: begin
                next_state = BYTE3;
            end

            BYTE3: begin
                done_reg  = 1'b1; // pulse done after third byte
                next_state = WAIT_START;
            end

            default: begin
                next_state = WAIT_START;
            end
        endcase
    end

    // Sequential state and done update
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
        end else begin
            state <= next_state;
        end
    end

    assign done = done_reg;

endmodule