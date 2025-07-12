module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] counter;

// Custom feedback logic for sequential counting
wire feedback = ~(counter[3] ^ counter[2] ^ counter[1] ^ counter[0]);

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0000;
    end
    else begin
        // Modified LFSR-style counting
        counter <= {counter[2:0], feedback} + (counter == 4'b1111 ? 4'b0001 : 4'b0000);
    end
end

assign q = counter;

endmodule