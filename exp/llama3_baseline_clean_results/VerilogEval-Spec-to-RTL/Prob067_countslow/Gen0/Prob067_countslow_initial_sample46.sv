module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000; // reset the counter to 0
    end else if (slowena) begin
        if (count == 4'd9) begin
            count <= 4'b0000; // wrap around to 0 when count reaches 9
        end else begin
            count <= count + 1; // increment the counter
        end
    end
end

assign q = count; // assign the count value to output q

endmodule