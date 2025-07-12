module TopModule(output reg zero);
    // Asynchronous reset tied to 1'b1 so zero is always reset to 0 and never set to 1
    always @(posedge 1'b0 or posedge 1'b1) begin
        if (1'b1)
            zero <= 1'b0;
        else
            zero <= zero;
    end
endmodule