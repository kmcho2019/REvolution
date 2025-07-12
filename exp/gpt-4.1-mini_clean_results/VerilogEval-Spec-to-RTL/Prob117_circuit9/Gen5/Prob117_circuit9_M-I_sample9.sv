module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

    localparam [2:0] CONST_FOUR = 3'd4;
    localparam [2:0] MAX_COUNT = 3'd6;

    always @(posedge clk) begin
        if (a) begin
            if (q != CONST_FOUR)
                q <= CONST_FOUR;
            // else retain q to avoid unnecessary toggle
        end else begin
            if (q == MAX_COUNT)
                q <= 3'd0;
            else
                q <= q + 3'd1;
        end
    end

    // Initial block only for simulation to set known start state matching waveform
    // synthesis translate_off
    initial begin
        q = CONST_FOUR;
    end
    // synthesis translate_on

endmodule