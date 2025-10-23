module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'b00;
            done       <= 1'b0;
        end else begin
            done <= 1'b0;
            if (byte_count == 2'b00) begin
                if (in[3]) 
                    byte_count <= 2'b01;
            end else begin
                byte_count <= byte_count + 1;
                if (byte_count == 2'b10) begin
                    done       <= 1'b1;
                    byte_count <= 2'b00;
                end
            end
        end
    end

endmodule