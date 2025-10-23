module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            if (in[3])       // start of a message
                count <= 2'd1;
            else if (count != 0)
                count <= count + 1;

            done <= (count == 2'd3);
        end
    end

endmodule