module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding representing partial matches of the sequence "10011":
    // S0 (0): no match yet
    // S1 (1): matched '1'
    // S2 (2): matched '10'
    // S3 (3): matched '100'
    // S4 (4): matched '1001'

    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4;

    reg [2:0] state;
    reg [2:0] next_state;

    // Synchronous state register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next-state logic using if-else structure
    always @(*) begin
        if (state == S0) begin
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end else if (state == S1) begin
            if (IN == 1'b0)
                next_state = S2;
            else
                next_state = S1;
        end else if (state == S2) begin
            if (IN == 1'b0)
                next_state = S3;
            else
                next_state = S1;  // Overlapping detection
        end else if (state == S3) begin
            if (IN == 1'b1)
                next_state = S4;
            else
                next_state = S0;
        end else if (state == S4) begin
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = S2;  // Overlapping detection
        end else begin
            next_state = S0;
        end
    end

    // Mealy output: MATCH is asserted when current state is S4 and IN=1 (last bit of sequence detected)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule