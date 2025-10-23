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
    reg clk_enable; // New enable signal for clock gating

    // Determine when to enable the clock
    always @(posedge clk) begin
        if (enable) begin
            clk_enable <= 1'b1; // Enable clock when module is active
        end else begin
            clk_enable <= 1'b0; // Disable clock when module is inactive
        end
    end

    // 8-bit shift register with clock gating
    always @(posedge clk) begin
        if (clk_enable) begin
            if (enable) begin
                Q[7:1] <= Q[6:0];
                Q[0] <= S;
            end
        end
    end

    // Simplified output assignment
    always @(*) begin
        Z = Q[{A, B, C}];
    end

endmodule