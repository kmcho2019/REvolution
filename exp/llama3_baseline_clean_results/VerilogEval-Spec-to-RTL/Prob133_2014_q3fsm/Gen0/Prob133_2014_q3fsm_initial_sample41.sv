module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2 states: A (0), B (1)
reg [1:0] w_count; // count of w = 1 in 3 cycles
reg [1:0] cycle_count; // count of cycles since entering state B
reg valid_cycle; // flag to indicate valid cycle counting

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        w_count <= 0;
        cycle_count <= 0;
        valid_cycle <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1;
                    w_count <= 0;
                    cycle_count <= 1;
                    valid_cycle <= 1;
                end else begin
                    state <= 0;
                end
            end
            1: begin // state B
                if (valid_cycle) begin
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                    cycle_count <= cycle_count + 1;
                    if (cycle_count == 3) begin
                        valid_cycle <= 0;
                        if (w_count == 2) begin
                            z <= 1;
                        end else begin
                            z <= 0;
                        end
                    end
                end else begin
                    if (w_count == 2) begin
                        z <= 0;
                    end
                    w_count <= 0;
                    cycle_count <= 1;
                    valid_cycle <= 1;
                end
            end
        endcase
    end
end

endmodule