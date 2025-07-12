module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // State encoding (one-hot style)
    localparam WAIT_START = 3'b001;
    localparam BYTE2      = 3'b010;
    localparam BYTE3      = 3'b100;

    reg [2:0] state, next_state;
    wire start_byte = in[3];

    // Next state logic
    always @(*) begin
        case (state)
            WAIT_START: 
                next_state = start_byte ? BYTE2 : WAIT_START;
            BYTE2:
                next_state = BYTE3;
            BYTE3:
                next_state = WAIT_START;
            default:
                next_state = WAIT_START;
        endcase
    end

    // Sequential state update and done generation
    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT_START;
            done  <= 1'b0;
        end else begin
            state <= next_state;
            done  <= (state == BYTE3);
        end
    end

endmodule