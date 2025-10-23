module TopModule (
    input clk,
    input a,
    output reg q
);

always @ (posedge clk) begin
    if (!a) begin
        if (q === 1'bx) begin // if q is unknown
            q <= 1'b1; // set q to 1 on the first clock cycle when a is 0
        end else begin
            q <= q; // keep q unchanged when a is 0
        end
    end else begin // a is 1
        q <= ~q; // toggle q
    end
end

endmodule