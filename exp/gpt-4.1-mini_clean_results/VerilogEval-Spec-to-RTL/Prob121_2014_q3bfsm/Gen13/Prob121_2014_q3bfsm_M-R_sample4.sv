module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // State encoding using localparam for clarity
    localparam STATE_000 = 3'b000,
               STATE_001 = 3'b001,
               STATE_010 = 3'b010,
               STATE_011 = 3'b011,
               STATE_100 = 3'b100;

    reg [2:0] state, next_state;

    // Next state logic - combinational via assign statements using a temporary signal
    wire [2:0] ns_from_0, ns_from_1, ns_from_2, ns_from_3, ns_from_4;
    
    assign ns_from_0 = (x == 1'b0) ? STATE_000 : STATE_001;
    assign ns_from_1 = (x == 1'b0) ? STATE_001 : STATE_100;
    assign ns_from_2 = (x == 1'b0) ? STATE_010 : STATE_001;
    assign ns_from_3 = (x == 1'b0) ? STATE_001 : STATE_010;
    assign ns_from_4 = (x == 1'b0) ? STATE_011 : STATE_100;

    assign next_state = (state == STATE_000) ? ns_from_0 :
                        (state == STATE_001) ? ns_from_1 :
                        (state == STATE_010) ? ns_from_2 :
                        (state == STATE_011) ? ns_from_3 :
                        (state == STATE_100) ? ns_from_4 :
                        STATE_000; // default fallback

    // Output logic as combinational assign based on state
    always @(*) begin
        case(state)
            STATE_011, STATE_100: z = 1'b1;
            default:             z = 1'b0;
        endcase
    end

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= STATE_000;
        else
            state <= next_state;
    end

endmodule