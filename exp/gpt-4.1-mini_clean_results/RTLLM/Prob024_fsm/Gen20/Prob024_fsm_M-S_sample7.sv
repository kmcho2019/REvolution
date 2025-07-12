module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (binary) for partial matches of "10011":
    // 0: no match (idle)
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    // 5: matched '10011' (final match state, transient)

    reg [2:0] state, next_state;

    // Sequential state update
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Next state logic with overlap handling
    always @(*) begin
        case (state)
            3'd0: next_state = (IN) ? 3'd1 : 3'd0;                 // Idle: if IN=1 -> '1', else stay
            3'd1: next_state = (IN) ? 3'd1 : 3'd2;                 // '1': IN=0 -> '10', IN=1 -> stay '1' (overlap)
            3'd2: next_state = (IN) ? 3'd1 : 3'd3;                 // '10': IN=0 -> '100', IN=1 -> restart '1'
            3'd3: next_state = (IN) ? 3'd4 : 3'd0;                 // '100': IN=1 -> '1001', else reset
            3'd4: next_state = (IN) ? 3'd1 : 3'd2;                 // '1001': IN=1 -> full match, overlap start '1'; IN=0 -> '10'
            default: next_state = 3'd0;
        endcase
    end

    // MATCH is Mealy output: asserted when current state is '1001' and IN=1 (completes "10011")
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule