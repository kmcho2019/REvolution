module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    reg [2:0] next_q;

    // Initialize q to 4 to avoid X at time 0 for simulation clarity
    initial begin
        q = 3'd4;
    end

    always @(*) begin
        if (a) begin
            next_q = 3'd4;  // Jump to 4 when a=1
        end else begin
            // Increment modulo 7 from 4...6, then wrap 0..3
            if (q < 3'd6)
                next_q = q + 3'd1;
            else if (q == 3'd6)
                next_q = 3'd0;
            else
                next_q = 3'd4;  // Recover invalid states
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule