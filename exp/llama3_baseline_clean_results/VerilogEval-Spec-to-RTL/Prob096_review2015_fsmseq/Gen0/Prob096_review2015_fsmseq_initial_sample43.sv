module TopModule(
    input         clk,
    input         reset,
    input         data,
    output        start_shifting
);

reg [2:0] state; // idle (3'b000), found_1 (3'b001), found_11 (3'b010), found_110 (3'b011), found_1101 (3'b100), shifting (3'b101)
reg         start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        start_shifting_reg <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // idle
                if (data == 1'b1) begin
                    state <= 3'b001;
                end else begin
                    state <= 3'b000;
                end
            end
            3'b001: begin // found_1
                if (data == 1'b1) begin
                    state <= 3'b010;
                end else if (data == 1'b0) begin
                    state <= 3'b000;
                end else begin
                    state <= 3'b001;
                end
            end
            3'b010: begin // found_11
                if (data == 1'b0) begin
                    state <= 3'b011;
                end else if (data == 1'b1) begin
                    state <= 3'b001;
                end else begin
                    state <= 3'b010;
                end
            end
            3'b011: begin // found_110
                if (data == 1'b1) begin
                    state <= 3'b100;
                end else if (data == 1'b0) begin
                    state <= 3'b000;
                end else begin
                    state <= 3'b011;
                end
            end
            3'b100: begin // found_1101
                state <= 3'b101;
            end
            3'b101: begin // shifting
                state <= 3'b101;
            end
            default: state <= 3'b000;
        endcase
        if (state == 3'b100 || state == 3'b101) begin
            start_shifting_reg <= 1'b1;
        end else begin
            start_shifting_reg <= 1'b0;
        end
    end
end

assign start_shifting = start_shifting_reg;

endmodule