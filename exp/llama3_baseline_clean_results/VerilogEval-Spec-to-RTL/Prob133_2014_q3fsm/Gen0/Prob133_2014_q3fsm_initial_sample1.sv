module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2 states: A (2'b00) and B (2'b01)
reg [1:0] w_count; // count the number of times w = 1
reg [1:0] clock_cycle; // count the clock cycles since entering state B

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // reset to state A
        w_count <= 2'b00;
        clock_cycle <= 2'b00;
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // state A
                if (s) begin
                    state <= 2'b01; // move to state B
                    w_count <= 2'b00;
                    clock_cycle <= 2'b00;
                end
            end
            2'b01: begin // state B
                clock_cycle <= clock_cycle + 1'b1;
                if (w) begin
                    w_count <= w_count + 1'b1;
                end
                if (clock_cycle == 2'b11) begin // three clock cycles have passed
                    if (w_count == 2'b10) begin
                        z <= 1'b1; // set z to 1 if w = 1 in exactly two clock cycles
                    end else begin
                        z <= 1'b0;
                    end
                    w_count <= 2'b00; // reset w_count
                    clock_cycle <= 2'b00; // reset clock_cycle
                end else begin
                    z <= 1'b0; // set z to 0 if not the fourth clock cycle
                end
            end
        endcase
    end
end

endmodule