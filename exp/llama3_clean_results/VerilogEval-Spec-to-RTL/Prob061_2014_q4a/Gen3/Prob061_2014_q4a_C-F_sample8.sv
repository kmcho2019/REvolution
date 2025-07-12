module TopModule (
    input clk, 
    input w, 
    input R, 
    input E, 
    input L, 
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        Q <= R; // Load value when L is asserted
    end else if (E) begin
        Q <= w; // Shift value when E is asserted
    end
    // Implicitly, Q retains its value when neither L nor E is asserted
end

endmodule