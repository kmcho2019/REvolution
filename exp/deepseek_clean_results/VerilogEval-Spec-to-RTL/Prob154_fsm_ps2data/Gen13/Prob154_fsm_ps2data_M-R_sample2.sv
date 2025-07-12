module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // One-hot state encoding
    reg [2:0] state;
    localparam IDLE = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    // Separate byte registers
    reg [7:0] byte1, byte2, byte3;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:   state <= in[3] ? BYTE1 : IDLE;
                BYTE1:  state <= BYTE2;
                BYTE2:  state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    // Data capture - only update when in corresponding state
    always @(posedge clk) begin
        if (reset) begin
            byte1 <= 8'bx;
            byte2 <= 8'bx;
            byte3 <= 8'bx;
        end else begin
            if (state == IDLE && in[3]) byte1 <= in;
            if (state == BYTE1) byte2 <= in;
            if (state == BYTE2) byte3 <= in;
        end
    end

    // Output assignments
    assign out_bytes = {byte1, byte2, byte3};
    assign done = (state == BYTE2);

endmodule