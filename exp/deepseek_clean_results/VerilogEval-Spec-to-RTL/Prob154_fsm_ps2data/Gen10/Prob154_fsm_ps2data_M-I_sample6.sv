module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    reg [2:0] state;
    localparam IDLE = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    // Byte registers with individual enables
    reg [7:0] byte1, byte2, byte3;
    reg byte1_en, byte2_en, byte3_en;
    reg next_done;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            next_done <= 0;
            byte1_en <= 0;
            byte2_en <= 0;
            byte3_en <= 0;
        end else begin
            // Default assignments
            byte1_en <= 0;
            byte2_en <= 0;
            byte3_en <= 0;
            next_done <= 0;

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        byte1_en <= 1;
                        state <= BYTE1;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                    byte2_en <= 1;
                    state <= BYTE2;
                end
                BYTE2: begin
                    byte3 <= in;
                    byte3_en <= 1;
                    next_done <= 1;
                    state <= IDLE;
                end
            endcase

            // Pipeline done signal
            done <= next_done;
        end
    end

    // Only update output bytes when enabled
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'bx;
        end else begin
            if (byte1_en) out_bytes[23:16] <= byte1;
            if (byte2_en) out_bytes[15:8] <= byte2;
            if (byte3_en) out_bytes[7:0] <= byte3;
        end
    end

endmodule