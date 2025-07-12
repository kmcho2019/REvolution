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

    // Shift register: shift left by one, shifting in S at Q[0]
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Output Z is selected by indexing Q with address {A,B,C}
    always @(*) begin
        Z = Q[{A,B,C}];
    end

endmodule