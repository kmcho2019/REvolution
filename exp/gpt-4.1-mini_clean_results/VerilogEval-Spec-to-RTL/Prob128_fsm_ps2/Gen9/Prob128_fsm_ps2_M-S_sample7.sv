module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            if (byte_count == 2'd0) begin
                if (in[3])
                    byte_count <= 2'd1;
            end else if (byte_count == 2'd2) begin
                done <= 1'b1;
                byte_count <= 2'd0;
            end else begin
                byte_count <= byte_count + 1'b1;
            end
        end
    end

endmodule