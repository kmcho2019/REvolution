module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    localparam [3:0] S0 = 4'd0;
    localparam [3:0] S1 = 4'd1;
    localparam [3:0] S2 = 4'd2;
    localparam [3:0] S3 = 4'd3;
    localparam [3:0] S4 = 4'd4;
    localparam [3:0] S5 = 4'd5;
    localparam [3:0] S6 = 4'd6;
    localparam [3:0] S7 = 4'd7;

    reg [3:0] state, next_state;
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        disc_reg = 0;
        flag_reg = 0;
        err_reg = 0;

        if (state == S5 && !in) begin
            disc_reg = 1;
        end
        else if (state == S6 && !in) begin
            flag_reg = 1;
        end
        else if (state == S7) begin
            err_reg = 1;
        end
    end

    // State and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
            disc <= disc_reg;
            flag <= flag_reg;
            err <= err_reg;
        end
    end

endmodule