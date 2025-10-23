module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [1:0] state; // 2 bits to represent 4 states
reg [2:0] counter; // 3 bits to count consecutive 1s
reg disc_reg, flag_reg, err_reg;

// Define the states
localparam IDLE = 2'b00;
localparam ONE = 2'b01;
localparam FIVE_ONES = 2'b10;
localparam SEVEN_ONES = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counter <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in) begin
                    state <= ONE;
                    counter <= 1;
                end else begin
                    state <= IDLE;
                    counter <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            ONE: begin
                if (in) begin
                    state <= ONE;
                    counter <= counter + 1;
                    if (counter == 5) state <= FIVE_ONES;
                    if (counter == 7) state <= SEVEN_ONES;
                end else begin
                    state <= IDLE;
                    counter <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            FIVE_ONES: begin
                if (in) begin
                    state <= ONE;
                    counter <= 1;
                    flag_reg <= 1;
                end else begin
                    state <= IDLE;
                    counter <= 0;
                    disc_reg <= 1;
                end
                err_reg <= 0;
            end
            SEVEN_ONES: begin
                if (~in) begin
                    state <= IDLE;
                    counter <= 0;
                end else begin
                    state <= SEVEN_ONES;
                    counter <= counter + 1;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 1;
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule