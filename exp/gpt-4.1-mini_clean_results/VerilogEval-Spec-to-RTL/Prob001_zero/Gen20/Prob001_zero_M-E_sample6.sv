module TopModule(output reg zero);
    initial zero = 1'b0;
    always @(*) begin
        // No update needed; zero remains 0
    end
endmodule