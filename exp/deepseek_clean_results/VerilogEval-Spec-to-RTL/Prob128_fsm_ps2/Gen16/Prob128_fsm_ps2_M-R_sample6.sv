module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // One-hot state encoding
    reg [2:0] state;
    localparam IDLE = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    // Next state logic
    wire next_IDLE = reset | (state == BYTE2);
    wire next_BYTE1 = (~reset) & ((state == IDLE & in[3]) | (state == BYTE1));
    wire next_BYTE2 = (~reset) & (state == BYTE1);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (1'b1)  // Synthesis-friendly case statement
                next_IDLE: state <= IDLE;
                next_BYTE1: state <= BYTE1;
                next_BYTE2: state <= BYTE2;
                default: state <= state;
            endcase
        end
    end

    // Output logic
    assign done = (state == BYTE2);

endmodule