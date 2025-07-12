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

    // 8:1 multiplexer using ABC as select lines
    assign Z = (C) ? 
               (B) ? 
               (A) ? Q[7] : Q[6] : 
               (A) ? Q[5] : Q[4] : 
               (B) ? 
               (A) ? Q[3] : Q[2] : 
               (A) ? Q[1] : Q[0];

endmodule