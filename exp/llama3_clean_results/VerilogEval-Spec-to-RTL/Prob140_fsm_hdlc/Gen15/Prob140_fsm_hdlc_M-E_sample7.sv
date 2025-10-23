module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // One-hot encoding for 3 states
reg [3:0] counter; // Counter for consecutive ones
reg disc_reg, flag_reg, err_reg;

localparam IDLE = 3'b001;
localparam FLAG_DETECT = 3'b010;
localparam ERROR_DETECT = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counter <= 0;
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
                    else state <= IDLE;
                end else begin
                    counter <= 0;
                    state <= IDLE;
                end
            end
            FLAG_DETECT: begin
                if (in) begin
                    counter <= counter + 1;
                    if (counter >= 7) state <= ERROR_DETECT;
                    else state <= FLAG_DETECT;
                end else begin
                    flag_reg <= 1;
                    state <= IDLE;
                    counter <= 0;
                end
            end
            ERROR_DETECT: begin
                if (~in) begin
                    state <= IDLE;
                    counter <= 0;
                end else begin
                    err_reg <= 1;
                    state <= ERROR_DETECT;
                end
            end
        endcase

        // Handle disc signal
        if (state == FLAG_DETECT && counter == 6 && ~in) begin
            disc_reg <= 1;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule