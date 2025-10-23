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

    // Shift register: shift in S at LSB on enable
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Multiplexer: output selected bit of Q
    assign Z = Q[{A,B,C}];

endmodule