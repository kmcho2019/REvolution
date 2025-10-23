module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    reg [7:0] Q;

    // 8-bit shift register with clock gating for power optimization
    always @(posedge clk) begin
        if (enable) begin
            Q[7:1] <= Q[6:0];
            Q[0] <= S;
        end else begin
            // Keep the state when enable is low to avoid unnecessary transitions
            Q <= Q;
        end
    end

    // Output assignment remains the same for simplicity and efficiency
    always @(*) begin
        Z = Q[{A, B, C}];
    end

endmodule