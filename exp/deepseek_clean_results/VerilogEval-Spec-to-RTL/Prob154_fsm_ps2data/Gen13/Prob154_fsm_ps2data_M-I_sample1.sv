module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state;
    reg [2:0] next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Data capture logic with enable
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'bx;
        end else begin
            if (state == IDLE && in[3]) begin
                out_bytes[23:16] <= in;
            end
            if (state == BYTE1) begin
                out_bytes[15:8] <= in;
            end
            if (state == BYTE2) begin
                out_bytes[7:0] <= in;
            end
        end
    end

    // Combinational done signal
    assign done = (state == BYTE2);

endmodule