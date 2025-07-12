module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    reg [1:0] count; // counts received bytes of current message: 0 = waiting

    always @(posedge clk) begin
        if (reset) begin
            count     <= 2'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            if (count == 0) begin
                // waiting for sync byte (in[3]==1)
                if (in[3]) begin
                    count <= 2'd1;
                    out_bytes <= {in, 16'd0}; // first byte goes to highest 8 bits
                end
            end else if (count < 3) begin
                count <= count + 1;
                out_bytes <= {out_bytes[15:0], in}; // shift in next byte
                if (count == 2) done <= 1'b1; // done on third byte received
            end else begin
                // after third byte done, reset count to 0 to wait new message
                count <= 2'd0;
            end
        end
    end

endmodule