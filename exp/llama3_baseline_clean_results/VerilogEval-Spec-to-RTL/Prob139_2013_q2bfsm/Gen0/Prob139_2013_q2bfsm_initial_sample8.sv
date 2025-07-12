module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // 3-bit state register
reg [1:0] count; // 2-bit counter for states C and D
reg f_reg, g_reg; // registers for outputs f and g

// initialize state and count
initial begin
    state = 3'b000; // state A
    count = 2'b00;
    f_reg = 1'b0;
    g_reg = 1'b0;
end

always @(posedge clk) begin
    if (!resetn) begin // reset
        state <= 3'b000; // state A
        count <= 2'b00;
        f_reg <= 1'b0;
        g_reg <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // state A
                if (resetn) begin
                    state <= 3'b001; // state B
                    f_reg <= 1'b1;
                end
            end
            3'b001: begin // state B
                state <= 3'b010; // state C
                f_reg <= 1'b0;
            end
            3'b010: begin // state C
                if (x) begin
                    if (count == 2'b00) begin
                        count <= count + 1;
                    end else if (count == 2'b01 && !x) begin
                        count <= count + 1;
                    end else if (count == 2'b10 && x) begin
                        state <= 3'b011; // state D
                        count <= 2'b00;
                    end
                end else if (count != 2'b00) begin
                    count <= 2'b00;
                end
            end
            3'b011: begin // state D
                g_reg <= 1'b1;
                if (y) begin
                    state <= 3'b100; // state E
                end else if (count == 2'b10) begin
                    state <= 3'b101; // state F
                end else begin
                    count <= count + 1;
                end
            end
            3'b100: begin // state E
                // maintain g = 1
            end
            3'b101: begin // state F
                g_reg <= 1'b0;
                // maintain g = 0
            end
            default: begin
                state <= 3'b000; // state A
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule