module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE2 = 3'b010;
    localparam BYTE3 = 3'b100;

    reg [2:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE:  next_state = (in[3]) ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // done is high when state machine is in BYTE3 (i.e., the third byte just received)
    assign done = (state == BYTE3);

endmodule