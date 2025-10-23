module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] input_num;  // register to store the input number
reg [4:0] bit_count;   // counter for the current bit position
reg [31:0] ones;       // register to store ones for 2's complement
reg start_conv;        // flag to indicate start of conversion
reg done_conv;         // flag to indicate end of conversion

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        input_num <= 0;
        bit_count <= 0;
        start_conv <= 0;
        done_conv <= 0;
        z <= 0;
    end else begin
        if (!start_conv) begin
            if (x == 1'b1) begin  // start conversion
                start_conv <= 1;
                input_num <= 1;
                bit_count <= 1;
            end
        end else if (!done_conv) begin
            input_num <= {input_num[30:0], x};  // shift left and add new bit
            bit_count <= bit_count + 1;
            if (x == 1'b0 && bit_count == 31) begin  // end of conversion
                done_conv <= 1;
            end
        end else begin
            ones <= ~input_num + 1;  // calculate 2's complement
            z <= ones[31 - bit_count];  // output 2's complement bit by bit
            bit_count <= bit_count - 1;
            if (bit_count == 0) begin
                start_conv <= 0;
                done_conv <= 0;
            end
        end
    end
end

endmodule