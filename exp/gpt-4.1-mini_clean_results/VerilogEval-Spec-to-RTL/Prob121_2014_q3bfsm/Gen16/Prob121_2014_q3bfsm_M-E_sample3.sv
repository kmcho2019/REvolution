module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire x,
    output reg  z
);

    // Define states with localparam for readability
    localparam STATE_000 = 3'b000,
               STATE_001 = 3'b001,
               STATE_010 = 3'b010,
               STATE_011 = 3'b011,
               STATE_100 = 3'b100;

    reg [2:0] state, next_state;

    // State register with synchronous reset and next-state update
    always @(posedge clk) begin
        if (reset)
            state <= STATE_000;
        else
            state <= next_state;
    end

    // Next state combinational logic encoded inside synchronous block for simplicity
    always @(*) begin
        case (state)
            STATE_000: next_state = (x) ? STATE_001 : STATE_000;
            STATE_001: next_state = (x) ? STATE_100 : STATE_001;
            STATE_010: next_state = (x) ? STATE_001 : STATE_010;
            STATE_011: next_state = (x) ? STATE_010 : STATE_001;
            STATE_100: next_state = (x) ? STATE_100 : STATE_011;
            default:   next_state = STATE_000;
        endcase
    end

    // Output logic combinational block based on current state
    always @(*) begin
        case (state)
            STATE_011: z = 1'b1;
            STATE_100: z = 1'b1;
            default:   z = 1'b0;
        endcase
    end

endmodule