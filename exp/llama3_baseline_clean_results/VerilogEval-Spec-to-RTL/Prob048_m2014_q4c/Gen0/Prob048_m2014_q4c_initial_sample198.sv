module TopModule(
    input clk,  // clock signal
    input d,   // data input
    input r,   // reset signal
    output reg q  // output
);

always @ (posedge clk) begin
    if (r) begin
        q <= 1'b0;  // reset output to 0 when 'r' is high
    end else begin
        q <= d;  // capture input 'd' when 'r' is low
    end
end

endmodule