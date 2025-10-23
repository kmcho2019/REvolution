module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    reg [1:0] count;

    // done is high when the third byte (count == 2) has just been received
    assign done = (count == 2);

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end else begin
            if (count == 0) begin
                if (in[3])
                    count <= 1;
            end else if (count == 2) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule