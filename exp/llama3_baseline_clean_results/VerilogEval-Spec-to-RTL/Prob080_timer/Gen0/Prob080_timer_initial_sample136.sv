module TopModule (
    input  clk,    // clock signal
    input  load,   // load signal
    input  [9:0] data,  // data to be loaded
    output tc      // terminal count signal
);

reg [9:0] counter;  // internal counter

always @(posedge clk) begin
    if (load) begin
        counter <= data;  // load new value
        tc <= 1'b0;  // reset tc signal
    end else if (counter > 0) begin
        counter <= counter - 1;  // decrement counter
    end
end

assign tc = (counter == 0)? 1'b1 : 1'b0;  // assert tc when counter reaches 0

endmodule