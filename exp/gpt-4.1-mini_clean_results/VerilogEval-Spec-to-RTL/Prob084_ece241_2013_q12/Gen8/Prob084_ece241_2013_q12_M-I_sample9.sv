module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;
    wire gated_clk;

    // Simple clock gating: gated_clk is active only when enable is high
    assign gated_clk = clk & enable;

    always @(posedge gated_clk) begin
        // Shift only on gated clock rising edge which implies enable is high
        Q <= {Q[6:0], S};
    end

    wire [2:0] sel = {A, B, C};
    assign Z = Q[sel];

endmodule