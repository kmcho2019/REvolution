module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] count;

always @(posedge clk) begin
    if (a) begin
        if (~a && ~a) begin // a goes from 0 to 1, reset to 4
            count <= 4;
        end else begin // a is 1, hold the count value
            count <= count;
        end
    end else begin // a is 0, increment the count
        count <= count + 1;
    end
end

assign q = count;

endmodule