module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // State encoding
    localparam WAIT_FOR_START = 2'b00;
    localparam BYTE2          = 2'b01;
    localparam BYTE3          = 2'b10;

    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_FOR_START;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            // Assert done when current state is BYTE3, meaning third byte just received
            done <= (state == BYTE3);
        end
    end

    always @(*) begin
        case (state)
            WAIT_FOR_START: next_state = in[3] ? BYTE2 : WAIT_FOR_START;
            BYTE2:          next_state = BYTE3;
            BYTE3:          next_state = WAIT_FOR_START;
            default:        next_state = WAIT_FOR_START;
        endcase
    end

endmodule