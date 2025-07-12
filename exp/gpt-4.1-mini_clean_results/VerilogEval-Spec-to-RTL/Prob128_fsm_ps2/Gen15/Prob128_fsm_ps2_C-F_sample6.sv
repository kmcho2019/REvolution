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
            done <= 1'b0; // Default done low each cycle

            case (count)
                2'd0: begin
                    // Wait for start byte where in[3] == 1
                    if (in[3])
                        count <= 2'd1;
                end
                2'd1: begin
                    // Second byte of message
                    count <= 2'd2;
                end
                2'd2: begin
                    // Third byte of message
                    done  <= 1'b1;  // Pulse done in cycle after third byte received
                    count <= 2'd0;  // Reset to wait for next message
                end
                default: count <= 2'd0;
            endcase
        end
    end

endmodule