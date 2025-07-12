module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    reg [2:0] state; // IDLE, BYTE1, BYTE2
    localparam IDLE = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    // Byte-wise registers with enable
    reg [7:0] byte1, byte2, byte3;
    reg byte1_en, byte2_en, byte3_en;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            byte1_en <= 1'b0;
            byte2_en <= 1'b0;
            byte3_en <= 1'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            byte1_en <= 1'b0;
            byte2_en <= 1'b0;
            byte3_en <= 1'b0;
            done <= 1'b0;

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte1 <= in;
                        byte1_en <= 1'b1;
                        state <= BYTE1;
                    end
                end
                BYTE1: begin
                    byte2 <= in;
                    byte2_en <= 1'b1;
                    state <= BYTE2;
                end
                BYTE2: begin
                    byte3 <= in;
                    byte3_en <= 1'b1;
                    done <= 1'b1;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Combine bytes only when done is asserted
    always @(*) begin
        if (done) begin
            out_bytes = {byte1, byte2, byte3};
        end else begin
            out_bytes = 24'bx;
        end
    end

endmodule