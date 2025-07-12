module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] johnson_counter;

always @(posedge clk) begin
    if (reset) begin
        johnson_counter <= 4'd0;
    end else if (johnson_counter == 4'd9) begin
        johnson_counter <= 4'd0;
    end else begin
        // Implementing the Johnson counter logic
        johnson_counter <= {johnson_counter[2:0], ~johnson_counter[3] & ~johnson_counter[2] & ~johnson_counter[1] & ~johnson_counter[0]};
    end
end

assign q = johnson_counter;

endmodule