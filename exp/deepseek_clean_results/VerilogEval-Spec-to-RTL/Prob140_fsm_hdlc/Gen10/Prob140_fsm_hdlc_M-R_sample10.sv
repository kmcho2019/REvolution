module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    localparam IDLE   = 3'd0;
    localparam COUNT1 = 3'd1;
    localparam COUNT2 = 3'd2;
    localparam COUNT3 = 3'd3;
    localparam COUNT4 = 3'd4;
    localparam COUNT5 = 3'd5;
    localparam COUNT6 = 3'd6;
    localparam ERROR  = 3'd7;

    reg [2:0] state, next_state;
    reg disc_reg, flag_reg, err_reg;

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

    // Output generation
    always @(*) begin
        disc_reg = 0;
        flag_reg = 0;
        err_reg = 0;
        
        case (state)
            COUNT5: disc_reg = ~in;
            COUNT6: flag_reg = ~in;
            ERROR:  err_reg = in;
        endcase
    end

    // State and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            {disc_reg, flag_reg, err_reg} <= 3'b0;
        end else begin
            state <= next_state;
        end
    end

    // Continuous assignments for outputs
    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule