module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // Byte count: 0 means waiting for start byte, 1..3 means message bytes received
    reg [1:0] count;
    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            count     <= 2'd0;
            done      <= 1'b0;
            out_bytes <= 24'd0;
            byte1     <= 8'd0;
            byte2     <= 8'd0;
            byte3     <= 8'd0;
        end else begin
            done <= 1'b0; // default done low

            if (count == 2'd0) begin
                // Waiting for start byte where in[3]==1
                if (in[3]) begin
                    byte1 <= in;
                    count <= 2'd1;
                end
            end else if (count == 2'd1) begin
                byte2 <= in;
                count <= 2'd2;
            end else if (count == 2'd2) begin
                byte3 <= in;
                // Assemble out_bytes when third byte arrives
                out_bytes <= {byte1, byte2, in};
                done <= 1'b1;
                count <= 2'd0; // reset for next message
            end
        end
    end

endmodule