module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    localparam IDLE  = 3'd0;
    localparam COUNT1 = 3'd1;
    localparam COUNT2 = 3'd2;
    localparam COUNT3 = 3'd3;
    localparam COUNT4 = 3'd4;
    localparam COUNT5 = 3'd5;
    localparam COUNT6 = 3'd6;
    localparam ERROR = 3'd7;

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:   next_state = in ? COUNT1 : IDLE;
            COUNT1: next_state = in ? COUNT2 : IDLE;
            COUNT2: next_state = in ? COUNT3 : IDLE;
            COUNT3: next_state = in ? COUNT4 : IDLE;
            COUNT4: next_state = in ? COUNT5 : IDLE;
            COUNT5: next_state = in ? COUNT6 : IDLE;
            COUNT6: next_state = in ? ERROR : IDLE;
            ERROR:  next_state = in ? ERROR : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    // Output logic (Moore style - outputs depend only on state)
    assign disc = (state == COUNT5) && !in;
    assign flag = (state == COUNT6) && !in;
    assign err = (state == ERROR) || ((state == COUNT6) && in);

endmodule