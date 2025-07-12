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
            Q <= {Q[6:0], S};  // Efficient vector shift operation
        end
    end

    assign Z = Q[{A, B, C}];  // Optimal direct-index mux implementation
endmodule