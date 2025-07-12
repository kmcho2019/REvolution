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

    // Next state logic: count consecutive ones or reset on zero input
    always @(*) begin
        if (in)
            next_state = (state < S7) ? (state + 3'd1) : S7;
        else
            next_state = S0;
    end

    // Outputs are asserted one cycle after detection:
    // disc: when current state is 5 and input == 0 (i.e. 5 ones followed by 0)
    // flag: when current state is 6 and input == 0 (6 ones followed by 0)
    // err: when next_state is 7 (7 or more consecutive ones)
    wire disc_int = (state == S5) && (in == 1'b0);
    wire flag_int = (state == S6) && (in == 1'b0);
    wire err_int  = (next_state == S7);

    // Sequential logic: update state and register outputs with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_int;
            flag  <= flag_int;
            err   <= err_int;
        end
    end

endmodule