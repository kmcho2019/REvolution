module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT
reg [1:0] count; // counter for shift cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // SHIFT state
        count <= 0;
        shift_ena <= 1'b1;
    end else begin
        case(state)
            1: begin // SHIFT state
                shift_ena <= 1'b1;
                count <= count + 1;
                if (count == 3) begin
                    state <= 0; // IDLE state
                end
            end
            0: begin // IDLE state
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule