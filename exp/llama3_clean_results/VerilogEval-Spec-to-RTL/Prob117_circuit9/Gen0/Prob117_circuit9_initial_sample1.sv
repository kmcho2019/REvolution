module TopModule(clk, a, q);
    input clk, a;
    output [2:0] q;

    reg [2:0] q;

    always @(posedge clk) begin
        if (a) begin
            // When a is 1, keep q at 4
            q <= 4;
        end else begin
            // When a is 0, increment q
            if (q == 7) begin
                // Wrap around from 7 to 0
                q <= 0;
            end else begin
                q <= q + 1;
            end
        end
    end

    // Initialize q to 4 when a is first asserted
    initial begin
        q <= 4;
    end
endmodule