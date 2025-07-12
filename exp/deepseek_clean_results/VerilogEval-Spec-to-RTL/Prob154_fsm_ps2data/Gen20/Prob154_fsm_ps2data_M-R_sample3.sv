module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // One-hot states: IDLE, FIRST, SECOND
    reg [2:0] state;
    reg [7:0] byte1, byte2, byte3;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b001;  // IDLE
        end else begin
            case (state)
                3'b001: if (in[3]) state <= 3'b010;  // IDLE -> FIRST
                3'b010: state <= 3'b100;              // FIRST -> SECOND
                3'b100: state <= 3'b001;              // SECOND -> IDLE
                default: state <= 3'b001;
            endcase
        end
    end

    // Byte capture logic
    always @(posedge clk) begin
        if (!reset) begin
            case (state)
                3'b001: if (in[3]) byte1 <= in;
                3'b010: byte2 <= in;
                3'b100: byte3 <= in;
            endcase
        end
    end

    // Output assignments
    assign out_bytes = (state == 3'b100) ? {byte1, byte2, byte3} : 24'bx;
    assign done = (state == 3'b100);

endmodule