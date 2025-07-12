module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire CE = L | E; // Clock enable signal

always @(posedge clk) begin
    if (CE) begin
        if (L)
            Q <= R;
        else
            Q <= w;
    end
    // else retain Q without toggling
end

endmodule