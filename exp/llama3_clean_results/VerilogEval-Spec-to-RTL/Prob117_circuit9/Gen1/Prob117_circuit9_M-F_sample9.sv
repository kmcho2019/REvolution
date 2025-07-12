module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] count;
reg prev_a;

always @(posedge clk) begin
    prev_a <= a;
    if (prev_a == 0 && a == 1) begin // a transitions from 0 to 1, reset to 4
        count <= 4;
    end else if (a == 0) begin // a is 0, increment the count
        count <= count + 1;
    end else begin // a is 1, hold the count value
        count <= count;
    end
end

assign q = count;

endmodule