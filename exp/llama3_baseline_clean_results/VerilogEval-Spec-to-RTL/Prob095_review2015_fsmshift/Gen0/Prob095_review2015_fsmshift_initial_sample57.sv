module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: shift_count_1, 3: shift_count_2
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // shifting
        shift_count <= 0;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            1'b1: begin // shifting
                if (shift_count == 4'd3) begin
                    state <= 1'b0; // idle
                    shift_ena <= 1'b0;
                end else begin
                    state <= 1'b1; // shifting
                    shift_ena <= 1'b1;
                    shift_count <= shift_count + 1'b1;
                end
            end
            1'b0: begin // idle
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule