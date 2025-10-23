module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            if (q != 3'd4)
                q <= 3'd4;
        end else begin
            case (q)
                3'd6: q <= 3'd0;
                default: q <= q + 3'd1;
            endcase
        end
    end

endmodule