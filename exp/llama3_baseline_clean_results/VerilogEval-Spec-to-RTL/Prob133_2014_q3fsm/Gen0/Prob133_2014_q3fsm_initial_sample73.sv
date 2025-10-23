module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // A = 2'b00, B = 2'b01, B_ext = 2'b10
reg [1:0] counter; // counts clock cycles in state B_ext
reg [1:0] w_counter; // counts w = 1 occurrences
reg z_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // reset state A
        counter <= 2'b00;
        w_counter <= 2'b00;
        z_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // state A
                if (s) begin
                    state <= 2'b01; // transition to state B
                end else begin
                    state <= 2'b00; // stay in state A
                end
            end
            2'b01: begin // state B
                state <= 2'b10; // transition to state B_ext
                counter <= 2'b01;
                w_counter <= w ? 2'b01 : 2'b00;
            end
            2'b10: begin // state B_ext
                counter <= counter + 1;
                if (w) begin
                    w_counter <= w_counter + 1;
                end
                if (counter == 2'b11) begin // three clock cycles passed
                    z_reg <= (w_counter == 2'b10) ? 1'b1 : 1'b0;
                    state <= 2'b01; // transition back to state B
                    counter <= 2'b00;
                    w_counter <= 2'b00;
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule