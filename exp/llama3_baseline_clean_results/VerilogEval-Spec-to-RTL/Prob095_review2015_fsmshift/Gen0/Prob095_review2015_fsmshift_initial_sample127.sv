module TopModule(
    input         clk,
    input         reset,
    output        shift_ena
);

reg [1:0] state; // Idle: 2'b00, Shifting: 2'b01
reg [1:0] counter; // 4-clock cycle counter

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01;
        counter <= 2'b00;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            2'b01: begin // Shifting
                if (counter == 2'b11) begin
                    state <= 2'b00;
                    counter <= 2'b00;
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 1'b1;
                    shift_ena <= 1'b1;
                end
            end
            2'b00: begin // Idle
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule