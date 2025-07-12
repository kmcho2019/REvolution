module TopModule(
    input clk,  // clock signal
    input d,    // input data
    input r,    // active high reset
    output reg q  // output q
);

always @(posedge clk) begin
    if (r) begin  // if reset is high, reset output q to 0
        q <= 0;
    end else begin  // otherwise, update output q with input d
        q <= d;
    end
end

endmodule