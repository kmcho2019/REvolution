module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    reg [1:0] byte_count;      // counts how many bytes received in current message: 0=searching, 1..3=bytes stored
    reg [7:0] byte1, byte2;

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done deasserted

            if (byte_count == 2'd0) begin
                // Searching for first byte: wait until in[3] == 1
                if (in[3]) begin
                    byte1 <= in;
                    byte_count <= 2'd1;
                end
            end else if (byte_count == 2'd1) begin
                // Store second byte
                byte2 <= in;
                byte_count <= 2'd2;
            end else if (byte_count == 2'd2) begin
                // Store third byte, form output, done will be asserted next cycle
                out_bytes <= {byte1, byte2, in};
                byte_count <= 2'd3;
            end else begin
                // byte_count == 3: signal done for one cycle, then reset counter to search again
                done <= 1'b1;
                byte_count <= 2'd0;
            end
        end
    end

endmodule