module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state;
reg [1:0] w_count;
reg [1:0] cycle_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        w_count <= 2'b00;
        cycle_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // state A
                if (s) begin
                    state <= 2'b01;
                    w_count <= 2'b00;
                    cycle_count <= 2'b01;
                end
                z <= 1'b0;
            end
            2'b01: begin // state B
                w_count <= w_count + (w ? 1'b1 : 1'b0);
                cycle_count <= cycle_count + 1'b1;
                if (cycle_count == 2'b11) begin
                    z <= (w_count == 2'b10) ? 1'b1 : 1'b0;
                    w_count <= 2'b00;
                    cycle_count <= 2'b01;
                end
            end
        endcase
    end
end

endmodule