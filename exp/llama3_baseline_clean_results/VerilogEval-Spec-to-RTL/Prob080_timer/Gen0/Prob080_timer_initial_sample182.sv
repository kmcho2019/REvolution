module TopModule(
    input         clk,     // clock signal
    input         load,    // load signal
    input  [9:0]  data,    // 10-bit data
    output        tc       // terminal count signal
);

reg [9:0] counter;  // internal counter

always @(posedge clk) begin
    if (load) begin
        // load the counter with the 10-bit data
        counter <= data;
    end else if (counter > 0) begin
        // decrement the counter
        counter <= counter - 1;
    end else begin
        // keep the counter at 0
        counter <= 0;
    end
end

// assign the tc signal
assign tc = (counter == 0)? 1'b1 : 1'b0;

endmodule