module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // One-hot state encoding
    localparam IDLE      = 3'b001;
    localparam FIRST     = 3'b010;
    localparam SECOND    = 3'b100;
    
    reg [2:0] state;
    reg [7:0] byte1, byte2, byte3;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:   if (in[3]) state <= FIRST;
                FIRST:  state <= SECOND;
                SECOND: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    // Byte capture logic
    always @(posedge clk) begin
        if (!reset) begin
            case (state)
                IDLE:   if (in[3]) byte1 <= in;
                FIRST:  byte2 <= in;
                SECOND: byte3 <= in;
            endcase
        end
    end

    // Combinational outputs
    assign done = (state == SECOND);
    assign out_bytes = done ? {byte1, byte2, byte3} : 24'bx;

endmodule