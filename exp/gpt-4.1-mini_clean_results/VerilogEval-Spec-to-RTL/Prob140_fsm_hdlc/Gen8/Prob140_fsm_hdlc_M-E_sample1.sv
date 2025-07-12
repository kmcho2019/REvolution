module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define named states for better readability
    typedef enum logic [3:0] {
        IDLE    = 4'd0,  // zero consecutive ones
        ONES_1  = 4'd1,
        ONES_2  = 4'd2,
        ONES_3  = 4'd3,
        ONES_4  = 4'd4,
        ONES_5  = 4'd5,
        ONES_6  = 4'd6,
        ERROR   = 4'd7   // 7 or more consecutive ones (error)
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = in ? ONES_1 : IDLE;
            ONES_1: next_state = in ? ONES_2 : IDLE;
            ONES_2: next_state = in ? ONES_3 : IDLE;
            ONES_3: next_state = in ? ONES_4 : IDLE;
            ONES_4: next_state = in ? ONES_5 : IDLE;
            ONES_5: next_state = in ? ONES_6 : IDLE;
            ONES_6: next_state = in ? ERROR  : IDLE;
            ERROR:  next_state = in ? ERROR  : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Outputs combinational logic based on current state and input
    // Outputs asserted for one cycle *after* detecting condition => register outputs
    wire disc_w = (state == ONES_5) && (in == 1'b0);
    wire flag_w = (state == ONES_6) && (in == 1'b0);
    wire err_w  = (state == ERROR);

    // Sequential logic: update state and register outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_w;
            flag  <= flag_w;
            err   <= err_w;
        end
    end

endmodule