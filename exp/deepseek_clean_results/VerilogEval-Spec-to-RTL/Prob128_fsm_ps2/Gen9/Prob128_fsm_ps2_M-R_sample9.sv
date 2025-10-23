module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] state;
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam BYTE3 = 2'b11;

    // Combinational output
    assign done = (state == BYTE3);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: 
                    if (in[3]) state <= BYTE1;
                BYTE1:
                    state <= BYTE2;
                BYTE2:
                    state <= BYTE3;
                BYTE3:
                    if (in[3]) state <= BYTE1;
                    else state <= IDLE;
                default:
                    state <= IDLE;
            endcase
        end
    end

endmodule