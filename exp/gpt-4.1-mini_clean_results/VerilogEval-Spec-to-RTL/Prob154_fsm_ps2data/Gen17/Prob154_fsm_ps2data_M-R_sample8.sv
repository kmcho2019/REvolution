module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output       done
);

    // State machine encoding: count how many bytes have been accepted
    // 0: waiting for first byte (in[3] == 1)
    // 1: received first byte
    // 2: received second byte
    // After third byte received, done asserted for one cycle, then reset to 0
    reg [1:0] byte_count;

    // Separate registers for each byte
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;

    // done asserted combinationally: when byte_count == 3, which means after third byte
    assign done = (byte_count == 2'd3);

    // Combine bytes to output as per spec: first byte high bits
    assign out_bytes = {byte1, byte2, byte3};

    // State transition and byte capture logic
    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
        end else begin
            case (byte_count)
                2'd0: begin
                    // Looking for a byte with in[3]==1 to start
                    if (in[3]) begin
                        byte1 <= in;
                        byte_count <= 2'd1;
                    end
                end

                2'd1: begin
                    byte2 <= in;
                    byte_count <= 2'd2;
                end

                2'd2: begin
                    byte3 <= in;
                    byte_count <= 2'd3;  // signals done cycle
                end

                2'd3: begin
                    // Done cycle, reset to search next message
                    byte_count <= 2'd0;
                end
            endcase
        end
    end

endmodule