module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count; // 4-bit register to hold the count

always @ (posedge clk) begin
    if (reset) begin // if reset is high, reset the count to 1
        count <= 4'd1; // 'd' denotes decimal, 4'd1 is decimal 1
    end else if (count == 4'd10) begin // if count is 10, wrap around to 1
        count <= 4'd1;
    end else begin // otherwise, increment the count
        count <= count + 4'd1;
    end
end

assign q = count; // assign the count to the output q

endmodule