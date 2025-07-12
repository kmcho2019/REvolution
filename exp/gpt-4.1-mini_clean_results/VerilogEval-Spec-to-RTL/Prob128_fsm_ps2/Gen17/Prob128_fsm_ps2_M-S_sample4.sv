module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    reg [1:0] count;

    // Count bytes of the message: 0 = waiting for start byte,
    // 1 and 2 = bytes received after start byte
    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
        end else begin
            if (count == 2'd0) begin
                if (in[3])
                    count <= 2'd1;
            end else if (count == 2'd2) begin
                count <= 2'd0;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

    // done is high for one clock cycle after third byte received
    assign done = (count == 2'd2);

endmodule