module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    reg [2:0] state; // 3-bit state register
    reg disc_reg, flag_reg, err_reg; // registers to hold output signals

    localparam IDLE = 3'b000; // initial state after reset
    localparam ONE = 3'b001;  // seen one 1
    localparam TWO = 3'b010;  // seen two 1s
    localparam THREE = 3'b011; // seen three 1s
    localparam FOUR = 3'b100;  // seen four 1s
    localparam FIVE = 3'b101;  // seen five 1s
    localparam SIX = 3'b110;   // seen six 1s
    localparam FLAG = 3'b111;  // seen flag pattern

    always @(posedge clk) begin
        if (reset) begin // reset FSM to initial state
            state <= IDLE;
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in) begin
                        state <= ONE;
                    end else begin
                        state <= IDLE;
                    end
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
                ONE: begin
                    if (in) begin
                        state <= TWO;
                    end else begin
                        state <= IDLE;
                    end
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
                TWO: begin
                    if (in) begin
                        state <= THREE;
                    end else begin
                        state <= IDLE;
                    end
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
                THREE: begin
                    if (in) begin
                        state <= FOUR;
                    end else begin
                        state <= IDLE;
                    end
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
                FOUR: begin
                    if (in) begin
                        state <= FIVE;
                    end else begin
                        state <= IDLE;
                    end
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
                FIVE: begin
                    if (in) begin
                        state <= SIX;
                    end else begin
                        state <= IDLE;
                    end
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
                SIX: begin
                    if (in) begin
                        state <= FLAG;
                        err_reg <= 1; // signal error
                    end else begin
                        state <= IDLE;
                        disc_reg <= 1; // signal discard
                    end
                    flag_reg <= 0;
                end
                FLAG: begin
                    if (in) begin
                        state <= FLAG;
                        err_reg <= 1; // continue signaling error
                    end else begin
                        state <= IDLE;
                    end
                    flag_reg <= 1; // signal flag
                    disc_reg <= 0;
                end
            endcase
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule