module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // A (2'b00), B (2'b01), C (2'b10), D (2'b11)
reg [1:0] count; // count of w = 1 cycles
reg [1:0] cycle; // current clock cycle

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // reset to state A
        count <= 2'b00;
        cycle <= 2'b00;
        z <= 0;
    end else begin
        case (state)
            2'b00: begin // state A
                if (s) begin
                    state <= 2'b01; // move to state B
                    count <= 2'b00;
                    cycle <= 2'b00;
                end
            end
            2'b01: begin // state B
                state <= 2'b10; // move to state C
                count <= 2'b00;
                cycle <= 2'b01;
            end
            2'b10: begin // state C
                if (w) begin
                    count <= count + 1'b1;
                end
                cycle <= cycle + 1'b1;
                if (cycle == 2'b11) begin
                    state <= 2'b11; // move to state D
                end
            end
            2'b11: begin // state D
                z <= (count == 2'b10)? 1'b1 : 1'b0; // set z based on count
                state <= 2'b10; // move back to state C
                cycle <= 2'b01;
            end
        endcase
    end
end

endmodule