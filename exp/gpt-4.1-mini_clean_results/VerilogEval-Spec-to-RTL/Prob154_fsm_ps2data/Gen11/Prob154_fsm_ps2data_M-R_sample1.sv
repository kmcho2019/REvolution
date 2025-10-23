module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output       done
);

    // State encoding using message byte counter:
    // 0 = searching for start byte (in[3] == 1)
    // 1 = first byte received
    // 2 = second byte received
    // 3 = third byte received (message complete)
    reg [1:0] msg_byte_cnt, msg_byte_cnt_next;

    // Registers to hold message bytes
    reg [7:0] byte1, byte2, byte3;

    // done is asserted combinationally when all 3 bytes collected
    assign done = (msg_byte_cnt == 2'd3);

    // Concatenate bytes with byte1 as highest 8 bits, etc.
    assign out_bytes = {byte1, byte2, byte3};

    // Next-state and byte loading logic
    always @(*) begin
        // Default next count is hold
        msg_byte_cnt_next = msg_byte_cnt;

        case(msg_byte_cnt)
            2'd0: begin
                // Wait for start byte
                if (in[3])
                    msg_byte_cnt_next = 2'd1;
            end
            2'd1: msg_byte_cnt_next = 2'd2;
            2'd2: msg_byte_cnt_next = 2'd3;
            2'd3: msg_byte_cnt_next = 2'd0;
            default: msg_byte_cnt_next = 2'd0;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            msg_byte_cnt <= 2'd0;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
        end else begin
            msg_byte_cnt <= msg_byte_cnt_next;

            case(msg_byte_cnt_next)
                2'd1: byte1 <= in;         // capture first byte with in[3] = 1
                2'd2: byte2 <= in;         // capture second byte
                2'd3: byte3 <= in;         // capture third byte
            endcase
        end
    end

endmodule