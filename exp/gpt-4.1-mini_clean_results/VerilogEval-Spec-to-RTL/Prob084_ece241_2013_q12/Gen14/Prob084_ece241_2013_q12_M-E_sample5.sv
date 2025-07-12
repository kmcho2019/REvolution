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

    // Shift register: shift left on enable with S shifted into Q[0]
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end

    // Output Z is selected by the 3-bit address {A,B,C} indexing Q
    always @(*) begin
        Z = Q[{A,B,C}];
    end

endmodule