module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // 0: A, 1: B, 2: C, 3: D
reg [1:0] counter; // counter for clock cycles since entering state B
reg [1:0] w_counter; // counter for clock cycles where w = 1
reg z_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset state
        counter <= 0;
        w_counter <= 0;
        z_reg <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1; // move to state B
                    counter <= 1;
                    w_counter <= w ? 1 : 0;
                end
            end
            1: begin // state B
                counter <= counter + 1;
                w_counter <= w_counter + (w ? 1 : 0);
                if (counter == 3) begin
                    state <= 0; // move back to state A to check output
                    if (w_counter == 2) begin
                        z_reg <= 1; // set output z to 1
                    end else begin
                        z_reg <= 0; // set output z to 0
                    end
                end
            end
            default: state <= 0;
        endcase
    end
end

assign z = z_reg;

endmodule