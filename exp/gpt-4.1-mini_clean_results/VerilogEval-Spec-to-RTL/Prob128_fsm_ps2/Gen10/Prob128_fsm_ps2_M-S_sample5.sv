module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'b0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0;  // default done cleared each cycle

            if (count == 2'b0) begin
                if (in[3]) begin
                    count <= 2'b1;
                end
            end else if (count == 2'b10) begin
                done  <= 1'b1;  // done after third byte
                count <= 2'b0;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule