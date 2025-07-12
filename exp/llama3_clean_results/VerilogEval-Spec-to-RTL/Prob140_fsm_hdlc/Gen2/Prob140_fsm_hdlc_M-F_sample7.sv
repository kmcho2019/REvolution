module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states
reg [2:0] ones; // counter for consecutive 1s
reg disc_reg, flag_reg, err_reg;

localparam IDLE = 3'b000;
localparam ONES = 3'b001;
localparam FLAG = 3'b010;
localparam ERROR = 3'b011;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        ones <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONES;
                    ones <= 1;
                end else begin
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
            end
            ONES: begin
                if (in) begin
                    ones <= ones + 1;
                    if (ones == 5) begin
                        state <= IDLE;
                        disc_reg <= 1;
                    end else if (ones == 6) begin
                        state <= FLAG;
                    end
                end else if (ones == 5) begin
                    state <= IDLE;
                    disc_reg <= 1;
                end else begin
                    state <= IDLE;
                    ones <= 0;
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
            end
            FLAG: begin
                if (~in) begin
                    state <= IDLE;
                    flag_reg <= 1;
                end else begin
                    state <= ERROR;
                    err_reg <= 1;
                end
            end
            ERROR: begin
                if (~in) begin
                    state <= IDLE;
                    err_reg <= 0;
                end else begin
                    err_reg <= 1;
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule