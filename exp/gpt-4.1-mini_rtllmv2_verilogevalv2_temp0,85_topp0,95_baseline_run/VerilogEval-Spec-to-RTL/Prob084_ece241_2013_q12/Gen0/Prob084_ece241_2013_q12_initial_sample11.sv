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
            Q <= {Q[6:0], S}; // shift left, S enters Q[0]
        end
    end

    // 3-bit select formed by CBA as per ABC order but with C as LSB
    wire [2:0] sel = {A, B, C};

    // Multiplexer to select Q[sel]
    assign Z = Q[sel];

endmodule