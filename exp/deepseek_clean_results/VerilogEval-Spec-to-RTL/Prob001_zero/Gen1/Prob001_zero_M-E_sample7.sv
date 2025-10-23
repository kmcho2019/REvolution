module TopModule (
    output reg zero
);
    always @(posedge clk or posedge clear) begin
        if (clear) zero <= 1'b0;
        else zero <= 1'b0;  // Always cleared
    end

    wire clk = 1'b0;        // Clock not needed but included for structure
    wire clear = 1'b1;      // Permanent clear
endmodule