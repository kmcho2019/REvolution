module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;

    wire start_msg = (count == 2'd0) && in[3];
    wire last_byte = (count == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            if (last_byte) begin
                count <= 2'd0;
                done  <= 1'b1;
            end else if (start_msg) begin
                count <= 2'd1;
                done  <= 1'b0;
            end else if (count != 2'd0) begin
                count <= count + 1'b1;
                done  <= 1'b0;
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule