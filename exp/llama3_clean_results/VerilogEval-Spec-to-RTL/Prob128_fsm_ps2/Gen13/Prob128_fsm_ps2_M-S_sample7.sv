module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        done <= 0;
    end
    else begin
        if (in[3] && byte_count == 0) begin
            byte_count <= 1;
        end
        else if (byte_count > 0 && byte_count < 3) begin
            byte_count <= byte_count + 1;
        end
        else if (byte_count == 3) begin
            byte_count <= 0;
        end
        done <= (byte_count == 3);
    end
end

endmodule