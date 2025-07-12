module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] temp_result;  // arbitrary length, can be increased as needed
reg [4:0] count;         // to keep track of number of bits received
reg [31:0] result;
reg done;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        temp_result <= 32'd0;
        count <= 5'd0;
        result <= 32'd0;
        done <= 1'b0;
        z <= 1'b0;
    end else if (!done) begin
        if (count == 5'd0) begin
            temp_result <= {31'd0, ~x};  // invert the input bit
        end else begin
            temp_result <= {temp_result[30:0], ~x};  // shift and invert the input bit
        end
        count <= count + 1'd1;
        if (x == 1'b1) begin
            result <= temp_result + 1;  // add 1 to get 2's complement
        end else begin
            result <= temp_result;
        end
        z <= result[31];  // output the most significant bit
        if (count == 5'd31) begin
            done <= 1'b1;
        end
    end
end

endmodule