module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] count;

always @ (posedge clk) begin
    if (reset) begin
        count <= 4'b0000; // reset counter to 0
    end else if (slowena) begin
        if (count == 4'b1001) begin // if count is 9, reset to 0
            count <= 4'b0000;
        end else begin
            count <= count + 1; // increment counter
        end
    end
end

assign q = count;

endmodule