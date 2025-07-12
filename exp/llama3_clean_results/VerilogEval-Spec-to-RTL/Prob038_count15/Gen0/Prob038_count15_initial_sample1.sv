module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0; // reset to 0 when reset signal is high
    end else begin
        if (count == 4'd15) begin
            count <= 4'd0; // reset to 0 when counter reaches 15
        end else begin
            count <= count + 1; // increment the counter
        end
    end
end

assign q = count; // assign the current count to output q

endmodule