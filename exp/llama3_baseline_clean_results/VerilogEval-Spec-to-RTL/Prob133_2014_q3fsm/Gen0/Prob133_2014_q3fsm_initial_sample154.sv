module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // A (2'b00), B (2'b01), C (2'b10), D (2'b11)
reg [1:0] count; // counter for w=1 in the last three clock cycles
reg [1:0] cycle; // current clock cycle (0-2)

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // reset to state A
        count <= 2'b00;
        cycle <= 2'b00;
        z <= 1'b0;
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
                if (w) begin
                    count <= count + 1'b1;
                end
                cycle <= cycle + 1'b1;
                if (cycle == 2'b11) begin
                    state <= 2'b00; // move back to state A
                    if (count == 2'b10) begin
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                end else begin
                    state <= 2'b01; // stay in state B
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

endmodule