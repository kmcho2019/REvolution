module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state;
reg [1:0] cycle_count;
reg w_count;

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // STATE_A
        z <= 0;
        cycle_count <= 0;
        w_count <= 0;
    end
    else begin
        case(state)
            2'b00: begin // STATE_A
                if(s) begin
                    state <= 2'b01; // STATE_B_CHECK
                    cycle_count <= 1;
                    w_count <= 0;
                end
            end
            2'b01: begin // STATE_B_CHECK
                if(cycle_count < 3) begin
                    if(w) begin
                        w_count <= w_count + 1;
                    end
                    cycle_count <= cycle_count + 1;
                end
                else begin
                    z <= (w_count == 2) ? 1 : 0;
                    state <= 2'b00; // STATE_A
                    cycle_count <= 0;
                    w_count <= 0;
                end
            end
        endcase
    end
end

endmodule