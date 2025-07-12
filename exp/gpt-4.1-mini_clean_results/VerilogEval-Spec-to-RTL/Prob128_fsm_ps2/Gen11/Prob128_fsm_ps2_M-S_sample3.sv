module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;

    always @(posedge clk) begin
        done <= 1'b0;

        if (reset) begin
            count <= 2'b00;
        end else if (count == 2'b00) begin
            if (in[3]) 
                count <= 2'b01;
        end else if (count == 2'b10) begin
            done  <= 1'b1;
            count <= 2'b00;
        end else begin
            count <= count + 1'b1;
        end
    end

endmodule