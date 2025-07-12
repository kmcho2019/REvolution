module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Continuous assignment for XOR
    assign out_assign = a ^ b;

    // Combined always block: updates combinational output on input change,
    // and sequential output on posedge clk.
    always @(posedge clk or a or b) begin
        if (clk) begin
            out_always_ff <= a ^ b;       // sequential update on clock edge
        end
        out_always_comb <= a ^ b;         // combinational update on input change
    end

endmodule