module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state, next_state;
    reg [7:0] byte1, byte2, byte3;
    reg byte_valid;
    reg gated_clk;

    // Clock gating logic
    always @(*) begin
        gated_clk = clk & (|state); // Only clock when not in IDLE
    end

    // State register with pipelined next_state
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic (simplified)
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Byte capture registers with clock gating
    always @(posedge gated_clk or posedge reset) begin
        if (reset) begin
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
        end else begin
            case (state)
                IDLE:  if (in[3]) byte1 <= in;
                BYTE1: byte2 <= in;
                BYTE2: byte3 <= in;
            endcase
        end
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'b0;
            done <= 0;
        end else if (state == BYTE2) begin
            out_bytes <= {byte1, byte2, in};
            done <= 1;
        end else begin
            done <= 0;
        end
    end

endmodule