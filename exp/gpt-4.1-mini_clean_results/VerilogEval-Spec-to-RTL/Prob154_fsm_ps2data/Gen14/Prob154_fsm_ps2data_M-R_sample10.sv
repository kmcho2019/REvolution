module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    // Use a 2-bit counter to track which byte of the message we are expecting:
    // 0 = waiting for sync byte (in[3] == 1)
    // 1 = received first byte (sync byte)
    // 2 = received second byte
    // 3 = received third byte (done)
    reg [1:0] byte_count;
    reg [7:0] byte_shift_reg[0:2]; // store 3 bytes separately

    // Sequential logic block: FSM state update, byte storage, and done generation
    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
            byte_shift_reg[0] <= 8'd0;
            byte_shift_reg[1] <= 8'd0;
            byte_shift_reg[2] <= 8'd0;
        end else begin
            done <= 1'b0; // default done low

            case (byte_count)
                2'd0: begin
                    // Waiting for sync byte: in[3] must be 1 to start message
                    if (in[3]) begin
                        byte_shift_reg[0] <= in;
                        byte_count <= 2'd1;
                    end
                end

                2'd1: begin
                    // Receive second byte
                    byte_shift_reg[1] <= in;
                    byte_count <= 2'd2;
                end

                2'd2: begin
                    // Receive third byte
                    byte_shift_reg[2] <= in;
                    byte_count <= 2'd3;
                end

                2'd3: begin
                    // Message complete: output concatenated bytes and assert done
                    out_bytes <= {byte_shift_reg[0], byte_shift_reg[1], byte_shift_reg[2]};
                    done <= 1'b1;
                    byte_count <= 2'd0;
                end

                default: begin
                    byte_count <= 2'd0;
                end
            endcase
        end
    end

endmodule