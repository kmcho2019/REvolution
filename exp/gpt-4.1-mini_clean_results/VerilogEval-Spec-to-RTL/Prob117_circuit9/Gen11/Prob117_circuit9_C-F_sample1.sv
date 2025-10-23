module TopModule (
    input        clk,
    input        rst_n,  // Active low asynchronous reset
    input        a,
    output reg [2:0] q
);

    localparam MODULO = 7;
    localparam CONST_FOUR = 3'd4;

    reg [2:0] next_q;

    // Next-state logic: 
    // If 'a' is high, force next_q to 4.
    // Else increment q modulo 7.
    always @(*) begin
        if (a)
            next_q = CONST_FOUR;
        else
            next_q = (q == MODULO - 1) ? 3'd0 : q + 3'd1;
    end

    // Sequential logic: register update with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= CONST_FOUR;  // Reset to 4 to match waveform initial known state
        else
            q <= next_q;
    end

endmodule