module TopModule(output reg zero, input wire reset_n, input wire clk);
    // On reset, zero is set to 0; it never changes afterward
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            zero <= 1'b0;
        else
            zero <= zero; // Hold the zero state
    end
endmodule