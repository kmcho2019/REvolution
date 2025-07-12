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
            done       <= 1'b0;
        end else begin
            done <= 1'b0; // default done low each cycle

            case (byte_count)
                2'd0: begin
                    // Waiting for start byte with in[3]=1
                    if (in[3])
                        byte_count <= 2'd1;
                end
                2'd1, 2'd2: begin
                    byte_count <= byte_count + 1'b1;
                end
                2'd3: begin
                    // Third byte received, signal done and reset counter
                    done       <= 1'b1;
                    byte_count <= 2'd0;
                end
            endcase
        end
    end

endmodule