module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    reg [2:0] state;  // One-hot: IDLE, BYTE1, BYTE2
    reg [7:0] byte1, byte2, byte3;

    // State definitions
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  if (in[3]) state <= BYTE1;
                BYTE1: state <= BYTE2;
                BYTE2: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    // Byte storage
    always @(posedge clk) begin
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

    // Output assignments
    assign done = (state == BYTE2);
    assign out_bytes = done ? {byte1, byte2, byte3} : 24'bx;

endmodule