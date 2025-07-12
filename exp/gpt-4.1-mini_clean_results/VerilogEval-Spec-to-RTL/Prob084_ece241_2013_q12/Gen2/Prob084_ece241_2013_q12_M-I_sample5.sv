module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;

    // 8-bit shift register with synchronous enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift left, MSB shifted in first
        end
    end

    // Direct indexing of Q by {A,B,C} as a 3-bit select
    assign Z = Q[{A,B,C}];

endmodule