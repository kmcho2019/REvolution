module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] johnson_counter;

always @(posedge clk) begin
    if (reset) begin
        johnson_counter <= 10'd0;
    end else begin
        johnson_counter <= {johnson_counter[8:0], ~johnson_counter[9]};
        if (johnson_counter == 10'd999) begin
            johnson_counter <= 10'd0;
        end
    end
end

assign q = johnson_counter;

endmodule