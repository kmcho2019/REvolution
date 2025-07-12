module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding - one-hot for clarity and timing
    localparam S0 = 4'b0001; // initial state, waiting for first '1'
    localparam S1 = 4'b0010; // matched first '1'
    localparam S2 = 4'b0100; // matched "10"
    localparam S3 = 4'b1000; // matched "100"
    localparam S4 = 4'b10000; // matched "1001" (extended state vector width)
    // Note: We actually need 5 states, so 5 bits
    // Adjust encoding accordingly
    
    // Re-encode states as 5-bit one-hot for all 6 states (including final)
    // Six states: S0, S1, S2, S3, S4, S5 (S5 is final matched state)
    // Adjusted state names:
    localparam [5:0]
        ST0 = 6'b000001, // initial
        ST1 = 6'b000010, // got 1
        ST2 = 6'b000100, // got 10
        ST3 = 6'b001000, // got 100
        ST4 = 6'b010000, // got 1001
        ST5 = 6'b100000; // got 10011 (final match state)

    reg [5:0] state, next_state;

    always @(posedge CLK) begin
        if (RST) begin
            state <= ST0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH output logic: output 1 only when entering ST5 (final state)
            MATCH <= (next_state == ST5);
        end
    end

    // Next-state combinational logic with one-hot states, supporting overlapping
    always @(*) begin
        case (state)
            ST0: next_state = (IN == 1'b1) ? ST1 : ST0;
            ST1: next_state = (IN == 1'b0) ? ST2 : ST1;
            ST2: next_state = (IN == 1'b0) ? ST3 : ST1; 
                // If input=1 at ST2, restart detecting from ST1 since input=1 matched
            ST3: next_state = (IN == 1'b1) ? ST4 : ST0;
            ST4: next_state = (IN == 1'b1) ? ST5 : ST2;
                // If input=0 at ST4, fallback to ST2 because "100" part matches start of pattern
            ST5: next_state = (IN == 1'b0) ? ST2 : ST1;
                // After match, prepare for overlapping sequences
            default: next_state = ST0;
        endcase
    end

endmodule