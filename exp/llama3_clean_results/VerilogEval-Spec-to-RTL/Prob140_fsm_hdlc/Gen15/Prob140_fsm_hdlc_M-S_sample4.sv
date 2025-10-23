module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // Simplified to 3 bits for 8 possible states
reg [2:0] ones_count; // Counter for consecutive ones
reg disc_reg, flag_reg, err_reg;

localparam IDLE = 3'b000;
localparam COUNT_ONES = 3'b001;
localparam ERROR = 3'b010;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        ones_count <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        case (state)
            IDLE: begin
                if (in) begin
                    state <= COUNT_ONES;
                    ones_count <= 1;
                end else begin
                    state <= IDLE;
                end
            end
            COUNT_ONES: begin
                if (in) begin
                    ones_count <= ones_count + 1;
                    if (ones_count == 5) begin
                        state <= COUNT_ONES;
                        disc_reg <= 1; // Signal to discard
                    end else if (ones_count == 6) begin
                        state <= IDLE;
                        flag_reg <= 1; // Signal flag
                    end else if (ones_count >= 7) begin
                        state <= ERROR;
                        err_reg <= 1; // Signal error
                    end
                end else begin
                    state <= IDLE;
                    ones_count <= 0;
                end
            end
            ERROR: begin
                if (~in) begin
                    state <= IDLE;
                    ones_count <= 0;
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule