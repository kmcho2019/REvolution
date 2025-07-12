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

    // Shift register: on enable shift right, shifting in S into MSB Q[7]
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S}; // Q[7] gets S, Q[6:0] shift right
        end
    end

    // Output Z is selected by the 3-bit address {A,B,C}, indexing into Q
    assign Z = Q[{A,B,C}];

endmodule