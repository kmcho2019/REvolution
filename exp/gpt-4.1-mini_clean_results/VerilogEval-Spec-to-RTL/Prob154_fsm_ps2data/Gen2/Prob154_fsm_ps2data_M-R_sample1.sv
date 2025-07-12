module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot states
    localparam IDLE  = 3'b001;
    localparam BYTE2 = 3'b010;
    localparam BYTE3 = 3'b100;

    reg [2:0] state;

    // Registers to hold bytes
    reg [7:0] byte1, byte2, byte3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'b0;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
        end else begin
            done <= 1'b0;  // default done low each cycle

            case (state)
                IDLE: begin
                    // Wait for start byte with in[3] = 1
                    if (in[3]) begin
                        byte1 <= in;
                        state <= BYTE2;
                    end else begin
                        state <= IDLE;
                    end
                end
                BYTE2: begin
                    byte2 <= in;
                    state <= BYTE3;
                end
                BYTE3: begin
                    byte3 <= in;
                    // On receiving third byte, output the message and assert done this cycle
                    out_bytes <= {byte1, byte2, in};
                    done <= 1'b1;
                    state <= IDLE;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule