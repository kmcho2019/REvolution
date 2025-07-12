module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// One-hot encoding of states
localparam S0 = 5'b00001; // Initial state, no match yet
localparam S1 = 5'b00010; // matched '1'
localparam S2 = 5'b00100; // matched '10'
localparam S3 = 5'b01000; // matched '100'
localparam S4 = 5'b10000; // matched '1001'

reg [4:0] state, next_state;

always @(*) begin
    // Default next state is S0 (reset state)
    next_state = S0;
    MATCH = 1'b0;

    case (state)
        S0: begin
            if (IN)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (~IN)
                next_state = S2;
            else
                next_state = S1; // remain if input is 1 again (partial repeat)
        end
        S2: begin
            if (~IN)
                next_state = S3;
            else
                next_state = S1;
        end
        S3: begin
            if (IN)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (IN) begin
                next_state = S1;
                MATCH = 1'b1; // Sequence "10011" matched at last '1'
            end else
                next_state = S2;
        end
        default: next_state = S0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        // MATCH is combinational, output set during next_state logic
        // To register MATCH output synchronously with state update:
        MATCH <= MATCH;
    end
end

endmodule