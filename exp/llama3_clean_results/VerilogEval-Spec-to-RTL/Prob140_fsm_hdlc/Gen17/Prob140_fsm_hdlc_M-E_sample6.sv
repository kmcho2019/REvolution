module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] counter; // Counter for consecutive ones
reg [1:0] state; // State machine for flag and error management
reg disc_reg, flag_reg, err_reg;

localparam IDLE = 2'b00;
localparam FLAG_DETECT = 2'b01;
localparam ERROR_DETECT = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
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
                if (in) begin
                    counter <= counter + 1;
                    if (counter == 5) state <= FLAG_DETECT;
                end else begin
                    counter <= 0;
                end
            end
            FLAG_DETECT: begin
                if (in) begin
                    counter <= counter + 1;
                    if (counter >= 7) state <= ERROR_DETECT;
                end else begin
                    state <= IDLE;
                    flag_reg <= 1;
                    counter <= 0;
                end
            end
            ERROR_DETECT: begin
                if (~in) begin
                    state <= IDLE;
                    counter <= 0;
                end else begin
                    err_reg <= 1;
                end
            end
        endcase

        // Discard bit when 5 consecutive ones are followed by a zero
        if (counter == 5 && ~in) disc_reg <= 1;
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule