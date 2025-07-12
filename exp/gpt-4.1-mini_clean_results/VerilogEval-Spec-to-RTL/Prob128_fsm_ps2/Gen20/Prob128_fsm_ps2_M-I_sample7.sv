module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    // Define states for clarity
    typedef enum reg [1:0] {
        WAIT   = 2'd0,
        BYTE1  = 2'd1,
        BYTE2  = 2'd2,
        BYTE3  = 2'd3
    } state_t;

    reg [1:0] state, next_state;
    reg       in3_d;  // registered in[3]

    // Register in[3] to improve timing and break combinational paths
    always @(posedge clk) begin
        if (reset)
            in3_d <= 1'b0;
        else
            in3_d <= in[3];
    end

    // Next state logic
    always @(*) begin
        done = 1'b0;
        case(state)
            WAIT:    next_state = in3_d ? BYTE1 : WAIT;
            BYTE1:   next_state = BYTE2;
            BYTE2:   next_state = BYTE3;
            BYTE3:   begin
                        next_state = WAIT;
                        done = 1'b1;  // done asserted one cycle after third byte
                     end
            default: next_state = WAIT;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= WAIT;
        else
            state <= next_state;
    end

endmodule