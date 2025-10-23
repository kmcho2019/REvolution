module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding: tracks number of consecutive 1s (0-7+)
    localparam S_0 = 0;   // Previous bit was 0
    localparam S_1 = 1;   // 1 consecutive 1
    localparam S_2 = 2;   // 2 consecutive 1s
    localparam S_3 = 3;   // 3 consecutive 1s
    localparam S_4 = 4;   // 4 consecutive 1s
    localparam S_5 = 5;   // 5 consecutive 1s
    localparam S_6 = 6;   // 6 consecutive 1s
    localparam S_ERR = 7; // 7+ consecutive 1s (error)

    reg [2:0] state, next_state;
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always @(*) begin
        case (state)
            S_0:    next_state = in ? S_1 : S_0;
            S_1:    next_state = in ? S_2 : S_0;
            S_2:    next_state = in ? S_3 : S_0;
            S_3:    next_state = in ? S_4 : S_0;
            S_4:    next_state = in ? S_5 : S_0;
            S_5:    next_state = in ? S_6 : S_0;
            S_6:    next_state = in ? S_ERR : S_0;
            S_ERR:  next_state = in ? S_ERR : S_0;
            default: next_state = S_0;
        endcase
    end

    // Corrected output logic (combinational)
    wire disc_next = (state == S_5) && !in;  // 0111110 pattern
    wire flag_next = (state == S_6) && !in;  // 01111110 pattern
    wire err_next  = (state == S_ERR);       // 01111111... pattern

    // State and output registration
    always @(posedge clk) begin
        if (reset) begin
            state <= S_0;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
        end else begin
            state <= next_state;
            disc_reg <= disc_next;
            flag_reg <= flag_next;
            err_reg <= err_next;
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule