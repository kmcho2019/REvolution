module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // One-hot state encoding
    localparam IDLE  = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;
    
    reg [2:0] state;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  state <= in[3] ? BYTE1 : IDLE;
                BYTE1: state <= BYTE2;
                BYTE2: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    // Output logic
    assign done = (state == BYTE2);

endmodule