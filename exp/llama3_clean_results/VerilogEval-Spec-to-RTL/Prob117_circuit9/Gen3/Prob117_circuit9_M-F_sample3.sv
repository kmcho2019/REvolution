module TopModule(clk, a, q);
    input clk, a;
    output [2:0] q;
    reg [2:0] q;
    reg a_prev; // To track the previous state of 'a'

    always @(posedge clk) begin
        // Update 'a_prev' for the next cycle
        a_prev <= a;

        if (a) begin
            // When 'a' is 1, set 'q' to 4
            q <= 4;
        end else if (!a && a_prev) begin
            // When 'a' transitions from 1 to 0, keep 'q' at 4 for this cycle
            q <= 4;
        end else if (!a && !a_prev) begin
            // When 'a' is 0 and was 0 in the previous cycle, increment 'q'
            if (q == 7) begin
                // Wrap around from 7 to 0
                q <= 0;
            end else begin
                q <= q + 1;
            end
        end
    end
endmodule