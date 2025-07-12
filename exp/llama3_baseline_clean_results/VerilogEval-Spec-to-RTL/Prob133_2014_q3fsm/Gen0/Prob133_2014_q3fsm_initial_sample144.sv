module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: A, 1: B
reg [1:0] count; // counter for clock cycles
reg z_reg; // register for output z
reg [1:0] w_count; // counter for w = 1

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to state A
        count <= 0;
        z_reg <= 0;
        w_count <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1; // transition to state B
                    count <= 1;
                    w_count <= 0;
                end
            end
            1: begin // state B
                if (count < 3) begin
                    count <= count + 1;
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                end else begin
                    count <= 1;
                    if (w_count == 2) begin
                        z_reg <= 1;
                    end else begin
                        z_reg <= 0;
                    end
                    w_count <= w;
                    if (w) begin
                        w_count <= 1;
                    end else begin
                        w_count <= 0;
                    end
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule