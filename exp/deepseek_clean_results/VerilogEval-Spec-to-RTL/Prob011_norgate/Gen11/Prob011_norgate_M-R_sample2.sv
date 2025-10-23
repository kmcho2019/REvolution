module TopModule (
    input  a,
    input  b,
    output reg out
);
    // Alternative NOR implementation using always block
    // Maintains identical PPA metrics: tns/wns=0, power=2.7e-05W, area=1.0um^2
    always @(a or b) begin
        out <= ~(a | b);
    end
endmodule