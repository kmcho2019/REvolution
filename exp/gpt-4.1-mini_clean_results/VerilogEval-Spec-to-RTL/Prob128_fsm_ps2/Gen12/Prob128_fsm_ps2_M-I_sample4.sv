module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            case (count)
                2'd0: begin
                    if (in[3]) 
                        count <= 2'd1;
                end
                2'd1, 2'd2: begin
                    count <= count + 1'b1;
                    if (count == 2'd2)
                        done <= 1'b1;
                end
                default: begin
                    // Defensive: reset count if invalid
                    count <= 2'd0;
                end
            endcase
        end
    end

endmodule