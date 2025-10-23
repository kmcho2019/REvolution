module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] johnson_counter;

always @(posedge clk) begin
    if (reset) begin
        johnson_counter <= 4'b0001; // Reset to 1
    end else begin
        // Johnson counter update logic
        johnson_counter <= {johnson_counter[2:0], ~johnson_counter[3] & johnson_counter[0]};
        
        // Wrap around to 1 after reaching 10
        if (johnson_counter == 4'd10) begin
            johnson_counter <= 4'b0001;
        end
    end
end

assign q = johnson_counter;

endmodule