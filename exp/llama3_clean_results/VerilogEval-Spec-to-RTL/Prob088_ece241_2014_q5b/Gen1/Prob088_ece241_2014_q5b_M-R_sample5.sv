module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] current_state;
reg z_reg;

// One-hot encoding for states
localparam A = 2'b01;
localparam B = 2'b10;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
        z_reg <= 0;
    end else begin
        case (current_state)
            A: begin
                if (x == 0) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
                z_reg <= x;
            end
            B: begin
                current_state <= B;
                z_reg <= ~x;
            end
        endcase
    end
end

assign z = z_reg;

endmodule