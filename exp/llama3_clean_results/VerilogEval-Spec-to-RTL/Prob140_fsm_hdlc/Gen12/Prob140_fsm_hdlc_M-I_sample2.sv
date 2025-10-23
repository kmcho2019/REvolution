module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states
reg disc_reg, flag_reg, err_reg;
reg [2:0] count;

// Define the states
localparam IDLE = 3'b000;
localparam ONE = 3'b001;
localparam FIVE_ONES = 3'b101;
localparam SIX_ONES = 3'b110;
localparam SEVEN_ONES = 3'b111;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
        count <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONE;
                    count <= 1;
                end else state <= IDLE;
            end
            ONE: begin
                if (in) begin
                    count <= count + 1;
                    if (count == 5) state <= FIVE_ONES;
                end else begin
                    state <= IDLE;
                    count <= 0;
                end
            end
            FIVE_ONES: begin
                if (in) state <= SIX_ONES;
                else begin
                    state <= IDLE;
                    disc_reg <= 1;
                    count <= 0;
                end
            end
            SIX_ONES: begin
                if (in) begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end else begin
                    state <= IDLE;
                    flag_reg <= 1;
                    count <= 0;
                end
            end
            SEVEN_ONES: begin
                if (~in) begin
                    state <= IDLE;
                    count <= 0;
                end else begin
                    state <= SEVEN_ONES;
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