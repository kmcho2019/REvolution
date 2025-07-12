module TopModule(
    input clk,
    input a,
    output reg q
);

initial q = 1; // Initialize q to 1

always @(posedge clk) begin
    if (~a) begin // If a is 0, set q to 1
        q <= 1;
    end else begin // If a is 1, set q to 0
        q <= 0;
    end
end

endmodule