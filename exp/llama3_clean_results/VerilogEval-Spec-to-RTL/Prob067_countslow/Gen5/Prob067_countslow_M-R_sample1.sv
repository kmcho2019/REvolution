module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] counter;
reg [3:0] next_counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'd0;
    end else if (slowena) begin
        counter <= next_counter;
    end
end

always @(*) begin
    if (counter == 4'd9) begin
        next_counter = 4'd0;
    end else begin
        next_counter = counter + 1;
    end
end

assign q = counter;

endmodule