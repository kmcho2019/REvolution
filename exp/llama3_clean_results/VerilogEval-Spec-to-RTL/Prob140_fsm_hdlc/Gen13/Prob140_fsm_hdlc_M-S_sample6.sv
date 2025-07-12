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

// Define the states
localparam IDLE = 3'b000;
localparam ONES = 3'b001;
localparam FURTHER_ONES = 3'b010;
localparam SIX_ONES = 3'b011;
localparam SEVEN_ONES = 3'b100;

reg [2:0] count;

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
                    state <= ONES;
                    count <= 1;
                end else begin
                    state <= IDLE;
                    count <= 0;
                end
            end
            ONES: begin
                if (in) begin
                    if (count == 3) begin
                        state <= FURTHER_ONES;
                        count <= 4;
                    end else begin
                        state <= ONES;
                        count <= count + 1;
                    end
                end else begin
                    state <= IDLE;
                    count <= 0;
                end
            end
            FURTHER_ONES: begin
                if (in) begin
                    if (count == 5) begin
                        state <= SIX_ONES;
                    end else begin
                        state <= FURTHER_ONES;
                        count <= count + 1;
                    end
                end else begin
                    state <= IDLE;
                    count <= 0;
                    disc_reg <= 1;
                end
            end
            SIX_ONES: begin
                if (in) begin
                    state <= SEVEN_ONES;
                    err_reg <= 1;
                end else begin
                    state <= IDLE;
                    count <= 0;
                    flag_reg <= 1;
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