module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state;
reg [1:0] count;
reg [1:0] w_count;
reg z_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // State A
        count <= 2'b00;
        w_count <= 2'b00;
        z_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01; // State B
                    count <= 2'b01;
                    w_count <= 2'b00;
                end
            end
            2'b01: begin // State B
                count <= count + 1;
                if (w) begin
                    w_count <= w_count + 1;
                end
                if (count == 3) begin
                    if (w_count == 2) begin
                        z_reg <= 1'b1;
                    end else begin
                        z_reg <= 1'b0;
                    end
                    state <= 2'b01; // Stay in State B
                    count <= 1;
                    w_count <= 0;
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule