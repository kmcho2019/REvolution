module TopModule(output reg one);
    // Asynchronous set to '1', asynchronous reset tied to 0, no clock needed
    always @(*) begin
        one = 1'b1;
    end
endmodule