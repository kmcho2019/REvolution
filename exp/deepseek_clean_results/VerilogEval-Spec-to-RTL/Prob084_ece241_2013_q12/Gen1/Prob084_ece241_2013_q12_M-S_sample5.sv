module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // 8-bit shift register
    reg [7:0] Q;
    
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift left, MSB first
        end
    end

    // Combine ABC into address and use direct indexing
    wire [2:0] addr = {A, B, C};
    assign Z = Q[addr];

endmodule