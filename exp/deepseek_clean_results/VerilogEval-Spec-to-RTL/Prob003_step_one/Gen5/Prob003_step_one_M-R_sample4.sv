module TopModule (
    output reg one
);
    // Alternative implementation using procedural assignment
    // Maintains identical PPA characteristics to direct assignment
    always @(*) begin
        one = 1'b1;
    end
endmodule