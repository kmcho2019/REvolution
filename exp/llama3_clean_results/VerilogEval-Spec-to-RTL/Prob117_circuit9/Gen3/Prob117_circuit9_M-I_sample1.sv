module TopModule(clk, a, q);
    input clk, a;
    output [2:0] q;

    reg [2:0] q;

    always @(posedge clk) begin
        if (a && q!= 4) begin
            // Set 'q' to 4 when 'a' is first asserted
            q <= 4;
        end else if (!a) begin
            // Increment 'q' when 'a' is 0, wrapping around from 7 to 0
            if (q == 7) begin
                q <= 0;
            end else begin
                q <= q + 1;
            end
        end
    end
endmodule