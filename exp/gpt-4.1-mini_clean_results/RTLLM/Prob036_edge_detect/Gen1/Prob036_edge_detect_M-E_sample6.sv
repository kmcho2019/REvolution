module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_sync1, a_sync2;

    always @(posedge clk) begin
        if (!rst_n) begin
            a_sync1 <= 1'b0;
            a_sync2 <= 1'b0;
            rise    <= 1'b0;
            down    <= 1'b0;
        end else begin
            a_sync1 <= a;
            a_sync2 <= a_sync1;

            rise <= 1'b0;
            down <= 1'b0;

            if (~a_sync2 & a_sync1)
                rise <= 1'b1;
            else if (a_sync2 & ~a_sync1)
                down <= 1'b1;
        end
    end

endmodule