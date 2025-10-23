module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Most efficient shift implementation
        end
    end
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    wire [7:0] Q;
    wire [2:0] sel = {A, B, C};  // Clean selector combination

    ShiftRegister8bit sr_inst (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    assign Z = Q[sel];  // Optimal direct-index mux
endmodule