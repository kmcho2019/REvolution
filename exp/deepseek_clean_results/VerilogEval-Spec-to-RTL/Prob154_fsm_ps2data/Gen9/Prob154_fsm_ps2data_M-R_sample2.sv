module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // One-hot state encoding
    reg [2:0] state;  // IDLE, GOT_BYTE1, GOT_BYTE2
    localparam IDLE = 3'b001;
    localparam GOT_BYTE1 = 3'b010;
    localparam GOT_BYTE2 = 3'b100;

    // Combinational done signal
    assign done = (state == GOT_BYTE2);

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: 
                    if (in[3]) state <= GOT_BYTE1;
                GOT_BYTE1: 
                    state <= GOT_BYTE2;
                GOT_BYTE2: 
                    state <= IDLE;
                default: 
                    state <= IDLE;
            endcase
        end
    end

    // Data storage logic
    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'bx;
        end else begin
            case (state)
                IDLE: 
                    if (in[3]) out_bytes[23:16] <= in;
                GOT_BYTE1: 
                    out_bytes[15:8] <= in;
                GOT_BYTE2: 
                    out_bytes[7:0] <= in;
            endcase
        end
    end

endmodule