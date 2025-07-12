module TopModule(
    input  clk,
    input  reset,
    input  [7:0] d,
    output [7:0] q
);

// internal wire to invert the clock signal
wire clk_inv;

// invert the clock signal
assign clk_inv = ~clk;

// D flip-flop with active high synchronous reset
always @(posedge clk_inv or posedge reset)
begin
    if (reset) 
    begin
        // reset to 0x34
        q <= 8'b00110100;
    end 
    else 
    begin
        // on negative edge of clk, load d into q
        q <= d;
    end
end

endmodule