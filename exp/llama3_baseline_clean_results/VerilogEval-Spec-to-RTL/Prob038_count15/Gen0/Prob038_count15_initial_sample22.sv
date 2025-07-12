module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @ (posedge clk) begin
    if (reset) begin
        count <= 4'd0; // Reset counter to 0 when reset is high
    end else if (count == 4'd15) begin
        count <= 4'd0; // Wrap around from 15 to 0
    end else begin
        count <= count + 1; // Increment counter
    end
end

assign q = count; // Assign the current count to the output

endmodule