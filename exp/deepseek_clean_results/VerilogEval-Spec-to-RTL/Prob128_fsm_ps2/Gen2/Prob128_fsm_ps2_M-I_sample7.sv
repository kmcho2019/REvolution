module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // One-hot state encoding
    reg [2:0] state;
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    // Combinational done signal
    assign done = (state == BYTE2) && (in[3] == 1'b0 || in[3] == 1'b1); // Any input triggers done after BYTE2

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: 
                    if (in[3] == 1'b1)
                        state <= BYTE1;
                    else
                        state <= IDLE;
                BYTE1:
                    state <= BYTE2;
                BYTE2:
                    state <= IDLE;
                default:
                    state <= IDLE;
            endcase
        end
    end

endmodule