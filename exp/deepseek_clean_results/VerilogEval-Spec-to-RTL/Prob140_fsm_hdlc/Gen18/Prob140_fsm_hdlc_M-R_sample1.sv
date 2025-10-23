module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    localparam IDLE = 3'd0;
    localparam S1   = 3'd1;
    localparam S2   = 3'd2;
    localparam S3   = 3'd3;
    localparam S4   = 3'd4;
    localparam S5   = 3'd5;
    localparam S6   = 3'd6;
    localparam ERR  = 3'd7;

    reg [2:0] state, next_state;
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = in ? S1 : IDLE;
            S1:   next_state = in ? S2 : IDLE;
            S2:   next_state = in ? S3 : IDLE;
            S3:   next_state = in ? S4 : IDLE;
            S4:   next_state = in ? S5 : IDLE;
            S5:   next_state = in ? S6 : IDLE;
            S6:   next_state = in ? ERR : IDLE;
            ERR:  next_state = in ? ERR : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (registered)
    always @(posedge clk) begin
        if (reset) begin
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end else begin
            disc_reg <= (state == S5) && !in;
            flag_reg <= (state == S6) && !in;
            err_reg <= (state == ERR) || ((state == S6) && in);
        end
    end

    // Continuous assignments for outputs
    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule