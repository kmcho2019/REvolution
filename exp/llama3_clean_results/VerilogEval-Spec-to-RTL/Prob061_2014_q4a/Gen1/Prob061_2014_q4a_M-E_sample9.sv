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
        Q <= R;
    end else if (E) begin
        Q <= w;
    end else begin
        Q <= Q; // Hold the current state
    end
end

// Alternatively, using a JK flip-flop
// reg J, K;
// always @(posedge clk) begin
//     if (L) begin
//         Q <= R;
//     end else if (E) begin
//         J <= w;
//         K <= ~w;
//     end else begin
//         J <= 0;
//         K <= 0;
//     end
// end
// assign Q = (J & ~Q) | (~K & Q);

endmodule