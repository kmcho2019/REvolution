module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// One-hot encoded states representing pattern progress:
// S0: initial/no match
// S1: matched '1'
// S2: matched '10'
// S3: matched '100'
// S4: matched '1001'
// The next input '1' at S4 produces a MATCH

localparam S0 = 5'b00001;
localparam S1 = 5'b00010;
localparam S2 = 5'b00100;
localparam S3 = 5'b01000;
localparam S4 = 5'b10000;

reg [4:0] state, next_state;

// Clock enable signals when input or state changes to reduce toggling power
reg prev_IN;
wire clk_en;

assign clk_en = (prev_IN != IN) || (state != next_state);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
        prev_IN <= 1'b0;
    end else if (clk_en) begin
        state <= next_state;
        prev_IN <= IN;
        // MATCH asserted when last bit '1' of pattern is detected (entering S4 with IN=1)
        MATCH <= (next_state == S4 && IN == 1'b1);
    end else begin
        // hold current state and MATCH
        MATCH <= 1'b0;
    end
end

always @(*) begin
    // Default next state is S0 to avoid latches
    next_state = S0;

    if (state == S0) begin
        // Wait for initial '1'
        next_state = IN ? S1 : S0;
    end else if (state == S1) begin
        // Matched '1'
        if (IN == 1'b0)
            next_state = S2; // matched '10'
        else
            next_state = S1; // still '1', stay here (pattern can start with multiple 1s)
    end else if (state == S2) begin
        // matched '10'
        if (IN == 1'b0)
            next_state = S3; // matched '100'
        else
            next_state = S1; // restart matching '1' since input '1'
    end else if (state == S3) begin
        // matched '100'
        if (IN == 1'b1)
            next_state = S4; // matched '1001'
        else
            next_state = S0; // reset on mismatch
    end else if (state == S4) begin
        // matched '1001'
        if (IN == 1'b1)
            next_state = S1; // matched full sequence on last '1', detect match & start new
        else
            next_state = S2; // possible overlap start with '0' after '1001'
    end else begin
        next_state = S0;
    end
end

endmodule