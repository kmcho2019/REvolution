module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    localparam IDLE   = 0;
    localparam COUNT1 = 1;
    localparam COUNT2 = 2;
    localparam COUNT3 = 3;
    localparam COUNT4 = 4;
    localparam COUNT5 = 5;
    localparam COUNT6 = 6;
    localparam ERROR  = 7;

    reg [2:0] state, next_state;
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:   next_state = in ? COUNT1 : IDLE;
            COUNT1:  next_state = in ? COUNT2 : IDLE;
            COUNT2:  next_state = in ? COUNT3 : IDLE;
            COUNT3:  next_state = in ? COUNT4 : IDLE;
            COUNT4:  next_state = in ? COUNT5 : IDLE;
            COUNT5:  next_state = in ? COUNT6 : IDLE;
            COUNT6:  next_state = in ? ERROR : IDLE;
            ERROR:  next_state = in ? ERROR : IDLE;
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        disc_reg = 0;
        flag_reg = 0;
        err_reg = 0;
        
        case (state)
            COUNT5: if (!in) disc_reg = 1;
            COUNT6: if (!in) flag_reg = 1;
            ERROR:  err_reg = 1;
        endcase
    end

    // State and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            {disc, flag, err} <= 3'b0;
        end else begin
            state <= next_state;
            // Register outputs to ensure they last one full cycle
            disc <= disc_reg;
            flag <= flag_reg;
            err <= err_reg;
        end
    end

endmodule