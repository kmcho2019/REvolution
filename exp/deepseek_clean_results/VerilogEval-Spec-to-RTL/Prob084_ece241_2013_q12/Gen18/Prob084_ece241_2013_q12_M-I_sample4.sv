module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    parameter WIDTH = 8;
    reg [WIDTH-1:0] Q;

    // Shift register implementation
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[WIDTH-2:0], S};  // Shift left with new bit at LSB
        end
    end

    // Efficient mux implementation using direct bit selection
    assign Z = Q[{A, B, C}];
endmodule