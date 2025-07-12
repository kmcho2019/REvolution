module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shift enable, 2: counter > 0, 3: final state
reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // shift enable state
        counter <= 0;
        shift_ena <= 1;
    end else begin
        case (state)
            1: begin // shift enable state
                if (counter == 3) begin
                    state <= 0; // idle state
                    shift_ena <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            0: begin // idle state
                // do nothing
            end
        endcase
    end
end

endmodule