module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [1:0] state; // 2 bits to represent 4 states using binary encoding
reg [2:0] count; // 3 bits to count consecutive 1s
reg disc_reg, flag_reg, err_reg;

// Define the states using binary encoding
localparam IDLE = 2'b00;
localparam ONE_TO_FIVE = 2'b01;
localparam SIX_ONES = 2'b10;
localparam SEVEN_ONES = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count <= 0;
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
                    state <= ONE_TO_FIVE;
                    count <= 1;
                end else begin
                    state <= IDLE;
                end
            end
            ONE_TO_FIVE: begin
                if (in) begin
                    count <= count + 1;
                    if (count == 5) begin
                        state <= SIX_ONES;
                    end
                end else if (count == 5) begin
                    disc_reg <= 1;
                    state <= IDLE;
                    count <= 0;
                end else begin
                    state <= IDLE;
                    count <= 0;
                end
            end
            SIX_ONES: begin
                if (in) begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end else begin
                    flag_reg <= 1;
                    state <= IDLE;
                end
            end
            SEVEN_ONES: begin
                if (~in) begin
                    state <= IDLE;
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