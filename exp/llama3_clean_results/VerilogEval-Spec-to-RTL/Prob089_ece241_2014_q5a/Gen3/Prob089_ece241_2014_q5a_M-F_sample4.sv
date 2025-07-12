module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] num = 32'd0; // to store the input number
reg [4:0] count = 5'd0; // to count the number of bits received
reg add_one = 1'b0; // flag to add 1
reg state = 1'b0; // 1'b0: idle, 1'b1: calculate

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;
        num <= 32'd0;
        count <= 5'd0;
        add_one <= 1'b0;
        z <= 1'b0;
    end else begin
        if (state == 1'b0 && ~areset) begin
            state <= 1'b1;
        end else if (state == 1'b1) begin
            if (x) begin
                add_one <= 1'b1; // if input bit is 1, set add_one flag
            end
            num <= {num[30:0], x}; // shift left and add new bit
            count <= count + 1'd1; // increment count
            if (count == 5'd31) begin // if 32 bits have been received
                z <= (~num[0]) + add_one; // calculate 2's complement and output
                state <= 1'b0; // reset state machine
                num <= 32'd0;
                count <= 5'd0;
                add_one <= 1'b0;
            end
        end
    end
end

endmodule