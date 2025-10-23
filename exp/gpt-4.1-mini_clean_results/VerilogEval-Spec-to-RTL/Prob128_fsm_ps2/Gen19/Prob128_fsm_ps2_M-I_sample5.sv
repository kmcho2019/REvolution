module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    reg [1:0] count;

    // done is combinationally asserted in the cycle immediately after third byte is received (when count was 2)
    assign done = (count == 2'd2);

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
        end else begin
            case (count)
                2'd0: begin
                    // Waiting for start byte with in[3] == 1
                    if (in[3])
                        count <= 2'd1;
                end
                2'd1: count <= 2'd2;
                2'd2: count <= 2'd0; // After done pulse, reset to wait for next start byte
                default: count <= 2'd0;
            endcase
        end
    end

endmodule