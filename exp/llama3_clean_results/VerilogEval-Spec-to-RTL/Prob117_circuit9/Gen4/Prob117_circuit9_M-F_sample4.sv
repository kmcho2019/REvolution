module TopModule(clk, a, q);
    input clk, a;
    output [2:0] q;

    reg [2:0] q;
    reg prev_a;

    always @(posedge clk) begin
        prev_a <= a;
        if (a && !prev_a) begin // 'a' transitions from 0 to 1
            // Set 'q' to 4 when 'a' is first asserted
            q <= 4;
        end else if (!a) begin // 'a' is 0
            // Increment 'q' when 'a' is 0, wrapping around from 7 to 0
            if (q == 7) begin
                q <= 0;
            end else begin
                q <= q + 1;
            end
        end
    end
endmodule