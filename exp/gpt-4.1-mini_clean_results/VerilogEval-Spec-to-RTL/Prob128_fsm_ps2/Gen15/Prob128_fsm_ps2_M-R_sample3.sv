module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // FSM states
    localparam IDLE  = 2'd0;
    localparam BYTE2 = 2'd1;
    localparam BYTE3 = 2'd2;

    reg [1:0] state, next_state;
    reg       done_reg;

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in[3])
                    next_state = BYTE2;
                else
                    next_state = IDLE;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                // After third byte, go back to IDLE waiting for next message
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // done asserted one cycle after receiving third byte (i.e. in BYTE3 state)
    assign done = (state == BYTE3);

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

endmodule