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

    // Shift register: shift right with MSB = S on enable
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Output selected by 3-bit address {A,B,C} indexing Q directly
    always @(*) begin
        Z = Q[{A,B,C}];
    end

endmodule