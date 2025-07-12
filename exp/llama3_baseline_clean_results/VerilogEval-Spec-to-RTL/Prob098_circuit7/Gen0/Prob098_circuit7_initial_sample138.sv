module TopModule (
    input  clk,
    input  a,
    output reg q
);

reg [1:0] count; // counter to track clock cycles

always @(posedge clk) begin
    if (a) begin
        if (count == 1'b1) begin // on the second clock cycle when a=1
            q <= ~q; // toggle the output
            count <= 1'b0; // reset the counter
        end else begin
            count <= count + 1'b1; // increment the counter
        end
    end else begin
        count <= 1'b0; // reset the counter when a=0
    end
end

endmodule