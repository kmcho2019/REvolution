module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [8:0] lower_counter;
reg [0:0] higher_counter;

always @(posedge clk) begin
    if (reset) begin
        lower_counter <= 9'd0;
        higher_counter <= 1'd0;
    end else begin
        if (lower_counter == 9'd511) begin
            lower_counter <= 9'd0;
            higher_counter <= ~higher_counter;
        end else begin
            lower_counter <= lower_counter + 9'd1;
        end
    end
end

assign q = {higher_counter, lower_counter};

endmodule