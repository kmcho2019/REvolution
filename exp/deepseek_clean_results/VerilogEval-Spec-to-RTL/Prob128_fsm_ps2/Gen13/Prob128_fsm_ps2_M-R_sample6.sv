module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    
    reg [1:0] state;

    // Combinational output
    assign done = (state == BYTE2);

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

endmodule