module TopModule (
    output reg zero
);
    always @(posedge 1'b1) begin  // Using a constant high as clock to simulate free-running
        zero <= 1'b0;
    end
endmodule