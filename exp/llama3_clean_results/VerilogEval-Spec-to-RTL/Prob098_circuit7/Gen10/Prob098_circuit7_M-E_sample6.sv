module TopModule(
    input clk,
    input a,
    output reg q
);

reg [1:0] counter;

// Initial counter value
initial counter = 2'b00;

// Counter logic
always @(posedge clk) begin
    if (a) begin
        counter <= counter + 1'b1;
    end else begin
        counter <= 2'b00;
    end
end

// Output q based on counter
always @(*) begin
    if (counter[0] == 1'b0) begin
        q = 1'b1;
    end else begin
        q = 1'b0;
    end
end

endmodule