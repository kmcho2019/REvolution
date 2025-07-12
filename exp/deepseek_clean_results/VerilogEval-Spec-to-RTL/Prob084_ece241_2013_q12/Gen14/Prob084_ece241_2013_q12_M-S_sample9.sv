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

    // 8-bit shift register
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // MSB first shift
        end
    end

    // 8:1 mux using direct array indexing
    assign Z = Q[{A, B, C}];
endmodule