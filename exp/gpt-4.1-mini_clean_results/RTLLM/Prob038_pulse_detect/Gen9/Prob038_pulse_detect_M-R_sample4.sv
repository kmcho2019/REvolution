module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    // State encoding (one-hot style)
    localparam WAIT_FOR_ZERO = 2'd0;
    localparam WAIT_FOR_ONE  = 2'd1;
    localparam WAIT_FOR_ZERO2= 2'd2;

    reg [1:0] state, next_state;

    // Sequential logic: state register update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            state <= WAIT_FOR_ZERO;
        else
            state <= next_state;
    end

    // Combinational: next state logic
    always @(*) begin
        case (state)
            WAIT_FOR_ZERO: begin
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_ONE;   // got 0, now wait for 1
                else
                    next_state = WAIT_FOR_ZERO;  // stay until 0 observed
            end

            WAIT_FOR_ONE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FOR_ZERO2; // got 1, wait for next 0
                else if (data_in == 1'b0)
                    next_state = WAIT_FOR_ONE;  // still waiting for 1, keep waiting
                else
                    next_state = WAIT_FOR_ZERO; // fallback (not reachable)
            end

            WAIT_FOR_ZERO2: begin
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_ZERO;  // pulse detected, return to start
                else
                    next_state = WAIT_FOR_ZERO2; // still waiting for 0
            end

            default: next_state = WAIT_FOR_ZERO;
        endcase
    end

    // Combinational output: data_out is high when transitioning from WAIT_FOR_ZERO2 to WAIT_FOR_ZERO
    // That is, pulse detected at the cycle when data_in==0 in WAIT_FOR_ZERO2 state
    assign data_out = (state == WAIT_FOR_ZERO2) && (data_in == 1'b0);

endmodule