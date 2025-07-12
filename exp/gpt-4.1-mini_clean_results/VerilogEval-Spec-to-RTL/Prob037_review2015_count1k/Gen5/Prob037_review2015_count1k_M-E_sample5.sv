module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end else begin
            case (q)
                10'd999: q <= 0;
                default: q <= q + 1;
            endcase
        end
    end

endmodule