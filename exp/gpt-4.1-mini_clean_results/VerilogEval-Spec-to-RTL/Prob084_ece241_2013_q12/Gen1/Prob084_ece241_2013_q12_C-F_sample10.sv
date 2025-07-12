module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);
    reg [7:0] Q;
    wire [2:0] addr = {A, B, C};

    // Shift register with synchronous active-high enable, shifting in S at Q[0]
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Combinational multiplexer using indexed access for output Z
    always @(*) begin
        Z = Q[addr];
    end
endmodule