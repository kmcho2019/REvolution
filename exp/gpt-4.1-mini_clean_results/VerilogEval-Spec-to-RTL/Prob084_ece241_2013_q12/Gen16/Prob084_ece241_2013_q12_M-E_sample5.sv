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

    // Shift register: shift left, inserting S into Q[7] on enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift left, MSB receives S
        end
    end

    // Combinational multiplexer using vector indexing by {A,B,C}
    assign Z = Q[{A, B, C}];

endmodule