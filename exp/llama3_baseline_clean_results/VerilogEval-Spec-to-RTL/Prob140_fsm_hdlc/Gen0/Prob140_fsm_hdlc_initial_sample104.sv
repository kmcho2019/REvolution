module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    enum logic [2:0] {
        IDLE = 3'b000,
        ONES1 = 3'b001,
        ONES2 = 3'b010,
        ONES3 = 3'b011,
        ONES4 = 3'b100,
        ONES5 = 3'b101,
        FLAG = 3'b110,
        ERROR = 3'b111
    } state, nextState;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (in) begin
                        state <= ONES1;
                    end else begin
                        state <= IDLE;
                    end
                end
                ONES1: begin
                    if (in) begin
                        state <= ONES2;
                    end else begin
                        state <= IDLE;
                    end
                end
                ONES2: begin
                    if (in) begin
                        state <= ONES3;
                    end else begin
                        state <= IDLE;
                    end
                end
                ONES3: begin
                    if (in) begin
                        state <= ONES4;
                    end else begin
                        state <= IDLE;
                    end
                end
                ONES4: begin
                    if (in) begin
                        state <= ONES5;
                    end else begin
                        state <= IDLE;
                    end
                end
                ONES5: begin
                    if (in) begin
                        disc <= 1'b1;
                        state <= ONES5;
                    end else begin
                        state <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
            if (in && state == ONES5) begin
                err <= 1'b1;
            end else if (in == 1'b0 && state == ONES5) begin
                flag <= 1'b1;
            end else if (state == IDLE) begin
                flag <= 1'b0;
                err <= 1'b0;
                disc <= 1'b0;
            end
        end
    end

endmodule