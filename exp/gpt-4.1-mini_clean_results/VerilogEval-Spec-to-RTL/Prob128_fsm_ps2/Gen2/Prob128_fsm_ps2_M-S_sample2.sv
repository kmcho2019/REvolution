module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    reg [1:0] byte_count; // 0 = searching, 1 or 2 = message bytes, 3 = third byte received

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
        end else begin
            case (byte_count)
                2'd0: begin
                    // Searching for message start: in[3] == 1 indicates first byte
                    if (in[3]) begin
                        byte_count <= 2'd1;
                    end
                end
                2'd1, 2'd2: begin
                    // Receiving 2nd or 3rd byte
                    byte_count <= byte_count + 2'd1;
                end
                2'd3: begin
                    // After done asserted, go back to searching
                    byte_count <= 2'd0;
                end
            endcase
        end
    end

    // done is asserted for one cycle immediately after third byte received (when byte_count == 3)
    assign done = (byte_count == 2'd3);

endmodule