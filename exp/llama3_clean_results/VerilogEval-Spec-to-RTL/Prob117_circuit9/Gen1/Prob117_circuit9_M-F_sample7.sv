module TopModule(clk, a, q);
    input clk, a;
    output [2:0] q;

    reg [2:0] q;
    reg a_asserted;

    always @(posedge clk) begin
        if (!a_asserted && a) begin
            // When 'a' is first asserted, set 'q' to 4 and set 'a_asserted' flag
            q <= 4;
            a_asserted <= 1;
        end else if (!a) begin
            // When 'a' is 0, increment 'q'
            if (q == 7) begin
                // Wrap around from 7 to 0
                q <= 0;
            end else begin
                q <= q + 1;
            end
        end
    end
endmodule