module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State definitions
    localparam [2:0] 
        COUNT0 = 3'd0,
        COUNT1 = 3'd1,
        COUNT2 = 3'd2,
        COUNT3 = 3'd3,
        COUNT4 = 3'd4,
        COUNT5 = 3'd5,
        COUNT6 = 3'd6,
        ERROR  = 3'd7;

    reg [2:0] current_state, next_state;
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= COUNT0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            COUNT0: next_state = in ? COUNT1 : COUNT0;
            COUNT1: next_state = in ? COUNT2 : COUNT0;
            COUNT2: next_state = in ? COUNT3 : COUNT0;
            COUNT3: next_state = in ? COUNT4 : COUNT0;
            COUNT4: next_state = in ? COUNT5 : COUNT0;
            COUNT5: next_state = in ? COUNT6 : COUNT0;
            COUNT6: next_state = in ? ERROR : COUNT0;
            ERROR: next_state = in ? ERROR : COUNT0;
            default: next_state = COUNT0;
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        disc_reg = 0;
        flag_reg = 0;
        err_reg = 0;

        case (current_state)
            COUNT5: if (!in) disc_reg = 1;
            COUNT6: if (!in) flag_reg = 1;
            ERROR: err_reg = 1;
            default: begin end
        endcase
    end

    // Output registers (synchronized)
    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= disc_reg;
            flag <= flag_reg;
            err <= err_reg;
        end
    end

endmodule