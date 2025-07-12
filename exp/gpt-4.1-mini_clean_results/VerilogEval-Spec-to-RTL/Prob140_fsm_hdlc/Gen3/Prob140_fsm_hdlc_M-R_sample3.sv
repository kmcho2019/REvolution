module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding as localparams
    localparam S0    = 4'd0; // 0 consecutive ones
    localparam S1    = 4'd1;
    localparam S2    = 4'd2;
    localparam S3    = 4'd3;
    localparam S4    = 4'd4;
    localparam S5    = 4'd5;
    localparam S6    = 4'd6;
    localparam DISC  = 4'd7; // disc output state
    localparam FLAG  = 4'd8; // flag output state
    localparam ERROR = 4'd9; // error state (7 or more ones)

    reg [3:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0:    next_state = in ? S1    : S0;
            S1:    next_state = in ? S2    : S0;
            S2:    next_state = in ? S3    : S0;
            S3:    next_state = in ? S4    : S0;
            S4:    next_state = in ? S5    : S0;
            S5:    next_state = in ? S6    : DISC;  // 5 ones then zero => DISC state
            S6:    next_state = in ? ERROR : FLAG;  // 6 ones then zero => FLAG, 7 ones => ERROR
            DISC:  next_state = S0;                 // one cycle disc output then back to S0
            FLAG:  next_state = S0;                 // one cycle flag output then back to S0
            ERROR: next_state = (in == 1'b0) ? S0 : ERROR; // error until input=0
            default: next_state = S0;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Moore outputs: combinational based on current state only
    assign disc = (state == DISC);
    assign flag = (state == FLAG);
    assign err  = (state == ERROR);

endmodule