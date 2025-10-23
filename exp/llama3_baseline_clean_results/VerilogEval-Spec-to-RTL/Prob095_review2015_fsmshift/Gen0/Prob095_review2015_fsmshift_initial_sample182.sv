module TopModule(
    input clk,
    input reset,
    output shift_ena
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT_1, 3: COUNT_2, (we use 2 bits to represent 4 states)
reg [1:0] count;

always @(posedge clk) begin
    if(reset) begin
        state <= 1; // SHIFT
        count <= 0;
        shift_ena <= 1;
    end else begin
        case(state)
            0: begin // IDLE
                shift_ena <= 0;
            end
            1: begin // SHIFT
                shift_ena <= 1;
                count <= count + 1;
                if(count == 3) begin
                    state <= 0; // transition back to IDLE
                end
            end
            default: begin
                shift_ena <= 0;
            end
        endcase
    end
end

endmodule