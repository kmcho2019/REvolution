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

    // Shift register with synchronous enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {S, Q[7:1]};
        end
    end

    // 3-bit address from A,B,C (A is MSB)
    wire [2:0] addr;
    assign addr = {A, B, C};

    // 8-to-1 multiplexer to select Q[addr]
    assign Z = Q[addr];

endmodule