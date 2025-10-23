module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT1, 3: COUNT2, 
reg [1:0] count;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Reset to SHIFT state
        count <= 0;
        shift_ena <= 1'b1;
    end else begin
        case (state)
            1'b1: begin // SHIFT state
                if (count == 4'd3) begin
                    state <= 1'b0; // Go to IDLE state
                    count <= 0;
                    shift_ena <= 1'b0;
                end else begin
                    count <= count + 1;
                end
            end
            1'b0: begin // IDLE state
                shift_ena <= 1'b0;
            end
            default: begin
                state <= 1'b0; // Go to IDLE state
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule