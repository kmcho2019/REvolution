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

    // Shift register with enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // 3-bit address from inputs A,B,C (A is MSB)
    wire [2:0] addr = {A, B, C};

    // 8-to-1 multiplexer to select Q[addr]
    assign Z = Q[addr];

endmodule