module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] counter;

always @(posedge clk) begin
    if (shift_ena) begin
        counter <= {data, counter[3:1]};
    end else if (count_ena && counter != 4'b0) begin
        counter <= counter - 1;
    end else begin
        counter <= counter; // Maintain current state when neither shift_ena nor count_ena is high, or counter is already 0.
    end
end

assign q = counter;

endmodule