module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // Current state register
reg [2:0] nxt_y; // Next state register
reg z_reg; // Output register

// Combinational logic to determine next state and output
always @(*) begin
    case (y)
        3'b000: begin
            nxt_y = x ? 3'b001 : 3'b000;
            z_reg = 1'b0;
        end
        3'b001: begin
            nxt_y = x ? 3'b100 : 3'b001;
            z_reg = 1'b0;
        end
        3'b010: begin
            nxt_y = x ? 3'b001 : 3'b010;
            z_reg = 1'b0;
        end
        3'b011: begin
            nxt_y = x ? 3'b010 : 3'b001;
            z_reg = 1'b1;
        end
        3'b100: begin
            nxt_y = x ? 3'b100 : 3'b011;
            z_reg = 1'b1;
        end
        default: begin
            nxt_y = 3'b000;
            z_reg = 1'b0;
        end
    endcase
end

// Sequential logic for state and output update
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
        z <= 1'b0;
    end else begin
        y <= nxt_y;
        z <= z_reg;
    end
end

endmodule