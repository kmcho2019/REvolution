module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

parameter WIDTH = 32; // Maximum input length
reg [WIDTH-1:0] shift_reg;
reg [WIDTH-1:0] inverted_shift_reg;
reg [WIDTH-1:0] carry_reg;
reg first_one_seen;
reg [1:0] state; // 0: Idle, 1: Convert, 2: Done

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 0;
        inverted_shift_reg <= 0;
        carry_reg <= 0;
        first_one_seen <= 0;
        state <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (x) begin
                    shift_reg[WIDTH-1] <= x;
                    first_one_seen <= 1;
                    state <= 1;
                end else begin
                    shift_reg[WIDTH-1] <= 0;
                end
            end
            1: begin // Convert
                // Shift input bit into shift register
                shift_reg <= {shift_reg[WIDTH-2:0], x};
                
                // Invert bits in shift register
                inverted_shift_reg <= ~shift_reg;
                
                // Handle carry propagation
                carry_reg <= inverted_shift_reg + 1;
                
                // Output converted bit
                z <= carry_reg[WIDTH-1];
                
                // Check if conversion is complete
                if (shift_reg[WIDTH-1] == 1) begin
                    state <= 2;
                end
            end
            2: begin // Done
                // Output final converted bit
                z <= carry_reg[WIDTH-1];
            end
        endcase
    end
end

endmodule