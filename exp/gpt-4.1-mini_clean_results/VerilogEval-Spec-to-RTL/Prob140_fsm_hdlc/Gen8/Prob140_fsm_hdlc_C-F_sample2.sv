module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: count of consecutive 1s (0..7)
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7; // error state (7 or more consecutive 1s)

    reg [2:0] state, next_state;
    reg prev_in;

    // Next state combinational logic with case statement on {state, in}
    always @(*) begin
        case ({state, in})
            // From S0
            {S0, 1'b0}: next_state = S0;
            {S0, 1'b1}: next_state = S1;
            // From S1
            {S1, 1'b0}: next_state = S0;
            {S1, 1'b1}: next_state = S2;
            // From S2
            {S2, 1'b0}: next_state = S0;
            {S2, 1'b1}: next_state = S3;
            // From S3
            {S3, 1'b0}: next_state = S0;
            {S3, 1'b1}: next_state = S4;
            // From S4
            {S4, 1'b0}: next_state = S0;
            {S4, 1'b1}: next_state = S5;
            // From S5
            {S5, 1'b0}: next_state = S0;
            {S5, 1'b1}: next_state = S6;
            // From S6
            {S6, 1'b0}: next_state = S0;
            {S6, 1'b1}: next_state = S7; // error: 7 or more consecutive ones
            // From S7 (error state)
            {S7, 1'b0}: next_state = S0;
            {S7, 1'b1}: next_state = S7;
            default:     next_state = S0;
        endcase
    end

    // Combinational output signals based on current state, prev_in, and input
    // disc: detected 0111110 = run of 5 ones followed by zero: state=5, prev_in=1, in=0
    wire disc_int = (state == S5) && (prev_in == 1'b1) && (in == 1'b0);
    // flag: detected 01111110 = run of 6 ones followed by zero: state=6, prev_in=1, in=0
    wire flag_int = (state == S6) && (prev_in == 1'b1) && (in == 1'b0);
    // err: next state is S7 (7 or more ones)
    wire err_int  = (next_state == S7);

    // Sequential logic: state, prev_in, outputs
    always @(posedge clk) begin
        if (reset) begin
            state   <= S0;
            prev_in <= 1'b0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            state   <= next_state;
            prev_in <= in;
            // register outputs to assert for one full cycle after detection
            disc    <= disc_int;
            flag    <= flag_int;
            err     <= err_int;
        end
    end

endmodule