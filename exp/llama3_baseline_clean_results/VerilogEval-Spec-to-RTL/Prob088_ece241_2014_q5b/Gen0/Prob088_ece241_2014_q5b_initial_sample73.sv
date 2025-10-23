module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;
reg z_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 2'b01; // Reset to state A
        z_reg <= 1'b0;
    end else begin
        current_state <= next_state;
        z_reg <= z;
    end
end

always @(*) begin
    case(current_state)
        2'b01: begin // State A
            if (x == 1'b0) begin
                next_state = 2'b01;
                z = 1'b0;
            end else begin
                next_state = 2'b10;
                z = 1'b1;
            end
        end
        2'b10: begin // State B
            next_state = 2'b10; // Self-loop
            if (x == 1'b0) begin
                z = 1'b1;
            end else begin
                z = 1'b0;
            end
        end
        default: begin // Invalid state
            next_state = 2'b01; // Reset to state A
            z = 1'b0;
        end
    endcase
end

assign z = z_reg;

endmodule