module TopModule(
    input clk,
    input a,
    output reg q
);

reg [1:0] counter; // 2-bit counter to track clock cycles since last change in 'a'
reg prev_a; // register to store previous value of 'a'

always @(posedge clk) 
begin
    if (a !== prev_a) // if 'a' has changed
    begin
        counter <= 0; // reset counter
        prev_a <= a; // update previous value of 'a'
        q <= ~a; // update output 'q' to inverted value of 'a'
    end
    else
    begin
        counter <= counter + 1; // increment counter
    end
end

endmodule