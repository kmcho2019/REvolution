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

    assign done = (state == BYTE2);  // Combinational output when in last state

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (in[3]) state <= BYTE1;  // Start message on in[3]=1
                BYTE1: state <= BYTE2;             // Move to next byte
                BYTE2: state <= IDLE;              // Message complete
                default: state <= IDLE;
            endcase
        end
    end

endmodule