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

    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift left, MSB first
        end
    end

    assign Z = Q[{A, B, C}];  // Direct bit-select mux
endmodule