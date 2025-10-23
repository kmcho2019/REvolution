module TopModule(
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
            done <= 1'b0; // default done de-assertion

            if (count == 2'd0) begin
                if (in[3])
                    count <= 2'd1;
            end else if (count == 2'd2) begin
                done  <= 1'b1;
                count <= 2'd0;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule