module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count = 1; // Initialize count to 1

always @(posedge clk) begin
    if (reset) begin // Check for reset condition
        count <= 1; // Reset count to 1 if reset is active high
    end else if (count == 10) begin // Check if count has reached 10
        count <= 1; // Reset count to 1
    end else begin // If neither reset nor count == 10, increment count
        count <= count + 1;
    end
end

assign q = count; // Assign the current count to the output q

endmodule