module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: enabling, 2: enabled, 3: done
reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // enabling
        counter <= 0;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            1: begin // enabling
                if (counter == 4'd3) begin
                    state <= 0; // idle
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 1;
                end
            end
            0: begin // idle
                shift_ena <= 1'b0;
            end
            default: begin
                // Do nothing
            end
        endcase
    end
end

endmodule