module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   in,
    output reg [23:0] out_bytes,
    output reg       done
);

    reg [1:0] byte_count;       // 0: waiting sync, 1: got byte1, 2: got byte2, 3: got byte3
    reg [23:0] shift_reg;       // shift in bytes: byte1 [23:16], byte2 [15:8], byte3 [7:0]

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            shift_reg  <= 24'd0;
            done       <= 1'b0;
            out_bytes  <= 24'd0;
        end else begin
            done <= 1'b0;  // default

            if (byte_count == 2'd0) begin
                // Waiting for sync byte where in[3] == 1
                if (in[3]) begin
                    // sync detected: store first byte and advance count
                    shift_reg <= {in, 16'd0}; // byte1 in [23:16]
                    byte_count <= 2'd1;
                end
            end else if (byte_count == 2'd1) begin
                // got byte1, get byte2
                shift_reg <= {shift_reg[15:0], in}; // shift left 8 bits, append new byte
                byte_count <= 2'd2;
            end else if (byte_count == 2'd2) begin
                // got byte2, get byte3
                shift_reg <= {shift_reg[15:0], in};
                byte_count <= 2'd3;
            end else begin
                // byte_count == 3: message complete, assert done and output bytes
                out_bytes <= shift_reg;
                done <= 1'b1;
                byte_count <= 2'd0;
            end
        end
    end

endmodule