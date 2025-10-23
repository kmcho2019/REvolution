module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] count;       // 0: searching for start byte, 1 or 2: bytes received
    reg [23:0] shift_reg;  // stores the 3-byte message as it is received

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            shift_reg <= 24'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low each cycle

            if (count == 2'd0) begin
                // Searching for start byte where in[3] == 1
                if (in[3]) begin
                    shift_reg <= {16'd0, in}; // load first byte in LSB
                    count <= 2'd1;
                end
            end else if (count == 2'd1) begin
                // Shift in second byte
                shift_reg <= {shift_reg[15:0], in};
                count <= 2'd2;
            end else if (count == 2'd2) begin
                // Shift in third byte and output message
                shift_reg <= {shift_reg[15:0], in};
                out_bytes <= {shift_reg[15:0], in}; // full 3-byte message
                done <= 1'b1;
                count <= 2'd0;
            end
        end
    end

endmodule