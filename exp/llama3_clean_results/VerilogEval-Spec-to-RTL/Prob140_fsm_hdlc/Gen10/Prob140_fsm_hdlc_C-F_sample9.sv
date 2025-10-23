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
localparam ONE = 3'b001;
localparam TWO = 3'b010;
localparam THREE = 3'b011;
localparam FOUR = 3'b100;
localparam FIVE = 3'b101;
localparam SIX = 3'b110;
localparam SEVEN = 3'b111;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        case (state)
            IDLE: begin
                if (in) state <= ONE;
                else state <= IDLE;
            end
            ONE: begin
                if (in) state <= TWO;
                else state <= IDLE;
            end
            TWO: begin
                if (in) state <= THREE;
                else state <= IDLE;
            end
            THREE: begin
                if (in) state <= FOUR;
                else state <= IDLE;
            end
            FOUR: begin
                if (in) state <= FIVE;
                else state <= IDLE;
            end
            FIVE: begin
                if (in) state <= SIX;
                else begin
                    state <= IDLE;
                    disc_reg <= 1;
                end
            end
            SIX: begin
                if (in) begin
                    state <= SEVEN;
                    err_reg <= 1;
                end else begin
                    state <= IDLE;
                    flag_reg <= 1;
                end
            end
            SEVEN: begin
                if (~in) state <= IDLE;
                else begin
                    state <= SEVEN;
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