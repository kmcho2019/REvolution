module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] johnson_counter;

always @(posedge clk) begin
    if (reset) begin
        johnson_counter <= 4'b1000;
    end else begin
        johnson_counter <= {~johnson_counter[3], johnson_counter[3:1]};
        if (johnson_counter == 4'b0000) begin
            johnson_counter <= 4'b1000;
        end
    end
end

assign q = johnson_counter;

endmodule