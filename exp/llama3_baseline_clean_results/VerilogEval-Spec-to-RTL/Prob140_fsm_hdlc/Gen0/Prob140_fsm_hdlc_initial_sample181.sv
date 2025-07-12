module TopModule(clk, reset, in, disc, flag, err);
    input clk, reset, in;
    output disc, flag, err;
    reg disc, flag, err;
    reg [2:0] state;

    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;
    localparam S5 = 3'b101;
    localparam S6 = 3'b110;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end
        else begin
            case (state)
                S0: begin
                    if (in) state <= S1;
                    else state <= S0;
                    disc <= 0;
                    flag <= 0;
                    err <= 0;
                end
                S1: begin
                    if (in) state <= S2;
                    else state <= S0;
                    disc <= 0;
                    flag <= 0;
                    err <= 0;
                end
                S2: begin
                    if (in) state <= S3;
                    else state <= S0;
                    disc <= 0;
                    flag <= 0;
                    err <= 0;
                end
                S3: begin
                    if (in) state <= S4;
                    else state <= S0;
                    disc <= 0;
                    flag <= 0;
                    err <= 0;
                end
                S4: begin
                    if (in) state <= S5;
                    else state <= S0;
                    disc <= 0;
                    flag <= 0;
                    err <= 0;
                end
                S5: begin
                    if (in) state <= S6;
                    else state <= S0;
                    disc <= 0;
                    flag <= 0;
                    err <= 0;
                end
                S6: begin
                    if (in) begin
                        state <= S6;
                        disc <= 0;
                        flag <= 0;
                        err <= 1;
                    end
                    else begin
                        state <= S0;
                        disc <= 1;
                        flag <= 1;
                        err <= 0;
                    end
                end
            endcase
        end
    end
endmodule