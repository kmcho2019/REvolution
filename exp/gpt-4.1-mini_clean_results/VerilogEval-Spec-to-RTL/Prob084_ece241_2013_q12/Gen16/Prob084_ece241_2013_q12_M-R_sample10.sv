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

    // Shift register: shift in S at Q[0], shift right on each clk with enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Multiplexer output Z assigned by indexing Q with ABC as address
    assign Z = Q[{A,B,C}];

endmodule