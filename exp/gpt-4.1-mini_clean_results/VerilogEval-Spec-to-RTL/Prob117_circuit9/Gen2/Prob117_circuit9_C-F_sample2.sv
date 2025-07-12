module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

    localparam [2:0] CONST_FOUR = 3'd4;
    localparam [2:0] MAX_COUNT = 3'd6;

    always @(posedge clk) begin
        if (a)
            q <= CONST_FOUR;
        else
            q <= (q == MAX_COUNT) ? 3'd0 : q + 3'd1;
    end

    // Optional deterministic initialization for simulation matching waveform start
    initial begin
        q = CONST_FOUR; // Matches first rising edge output of 4 when a=1 at start
    end

endmodule