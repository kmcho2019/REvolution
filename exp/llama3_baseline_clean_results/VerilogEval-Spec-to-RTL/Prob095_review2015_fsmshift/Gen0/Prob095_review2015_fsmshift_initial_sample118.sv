module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // 0: idle, 1: count, 2: end_count, 3: end
reg [1:0] count;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // go to count state
        count <= 0;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            1: begin // count state
                if (count == 4'd3) begin
                    state <= 0; // transition to idle state
                    shift_ena <= 1'b0;
                end else begin
                    count <= count + 1;
                    shift_ena <= 1'b1;
                end
            end
            0: begin // idle state
                shift_ena <= 1'b0;
            end
            default: begin
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule