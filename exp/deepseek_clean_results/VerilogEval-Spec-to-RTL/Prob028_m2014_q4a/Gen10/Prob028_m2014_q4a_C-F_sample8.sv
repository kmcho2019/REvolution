module TopModule (
    input d,
    input ena,
    output reg q
);

// synthesis attribute latch of q is "yes"
// synthesis attribute power_optimization of q is "high"

// D-latch implementation using always block
// q follows d when ena is high, retains value when ena is low
always @(ena or d) begin
    if (ena) begin
        q = d;
    end
end

endmodule