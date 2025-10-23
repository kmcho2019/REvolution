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

    // Shift register with synchronous active-high enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Combinational multiplexer using direct indexed access
    always @(*) begin
        Z = Q[{A,B,C}];
    end

endmodule