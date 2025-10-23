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

    // Registers for each byte with clock enable
    reg [7:0] byte1, byte2, byte3;

    // Clock enables for byte registers
    wire ce_byte1 = (state == IDLE) && in[3];
    wire ce_byte2 = (state == BYTE2);
    wire ce_byte3 = (state == BYTE3);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
            done <= 1'b0;
            out_bytes <= 24'b0;
        end else begin
            done <= 1'b0; // default done low

            // Latch bytes with enables to reduce toggling
            if (ce_byte1)
                byte1 <= in;
            if (ce_byte2)
                byte2 <= in;
            if (ce_byte3)
                byte3 <= in;

            // FSM state transitions
            case(state)
                IDLE: begin
                    if (in[3])
                        state <= BYTE2;
                end
                BYTE2: state <= BYTE3;
                BYTE3: begin
                    state <= IDLE;
                    done <= 1'b1;
                    // Update out_bytes only when done asserted
                    out_bytes <= {byte1, byte2, in};
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule