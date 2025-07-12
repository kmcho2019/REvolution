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
            done <= 1'b0; // default done low each cycle

            case (count)
                2'd0: begin
                    // Waiting for start byte where in[3]==1
                    if (in[3])
                        count <= 2'd1; // start of message detected
                end
                2'd1: begin
                    count <= 2'd2; // second byte received
                end
                2'd2: begin
                    done  <= 1'b1; // third byte received - pulse done
                    count <= 2'd0; // reset to wait for next start byte
                end
                default: count <= 2'd0; // safety fallback
            endcase
        end
    end

endmodule