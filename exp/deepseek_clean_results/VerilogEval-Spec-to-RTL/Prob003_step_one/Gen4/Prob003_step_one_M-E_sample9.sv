module TopModule (
    output reg one
);
    initial begin
        one = 1'b0;  // Initialize to 0
    end

    always @(*) begin
        one = 1'b1;  // Combinational override to always drive 1
    end
endmodule