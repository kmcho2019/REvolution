module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // state machine state
localparam IDLE = 3'b000; // initial state
localparam ONES_1 = 3'b001; // one consecutive 1
localparam ONES_2 = 3'b010; // two consecutive 1s
localparam ONES_3 = 3'b011; // three consecutive 1s
localparam ONES_4 = 3'b100; // four consecutive 1s
localparam ONES_5 = 3'b101; // five consecutive 1s
localparam ONES_6 = 3'b110; // six consecutive 1s

reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONES_1;
                end else begin
                    state <= IDLE;
                end
            end
            ONES_1: begin
                if (in) begin
                    state <= ONES_2;
                end else begin
                    state <= IDLE;
                end
            end
            ONES_2: begin
                if (in) begin
                    state <= ONES_3;
                end else begin
                    state <= IDLE;
                end
            end
            ONES_3: begin
                if (in) begin
                    state <= ONES_4;
                end else begin
                    state <= IDLE;
                end
            end
            ONES_4: begin
                if (in) begin
                    state <= ONES_5;
                end else begin
                    state <= IDLE;
                end
            end
            ONES_5: begin
                if (in) begin
                    state <= ONES_6;
                end else begin
                    state <= IDLE;
                    disc_reg <= 1; // discard bit
                end
            end
            ONES_6: begin
                if (in) begin
                    state <= ONES_6;
                    err_reg <= 1; // error
                end else begin
                    state <= IDLE;
                    flag_reg <= 1; // flag
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase

        // reset output registers
        if (state != ONES_5) begin
            disc_reg <= 0;
        end
        if (state != ONES_6 && in == 0) begin
            flag_reg <= 0;
        end
        if (state != ONES_6 || in == 0) begin
            err_reg <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule