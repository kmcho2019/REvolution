module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] accumulate_reg; // Register to store accumulated input bits
reg [7:0] output_reg; // Register to store current output bits
reg [1:0] state; // Finite State Machine state register (2 states: accumulate and complement)

// Define states
localparam IDLE = 2'b00;
localparam ACCUMULATE = 2'b01;
localparam COMPLEMENT = 2'b10;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        accumulate_reg <= 8'b0;
        output_reg <= 8'b0;
    end else begin
        case (state)
            IDLE: begin
                // Wait for reset to be released
                if (~areset) begin
                    state <= ACCUMULATE;
                end
            end
            ACCUMULATE: begin
                // Accumulate input bits
                accumulate_reg <= {accumulate_reg[6:0], x};
                // Check if reset is asserted to stop accumulation
                if (areset) begin
                    state <= IDLE;
                end else if (accumulate_reg == 8'b1) begin
                    // Transition to complement state when all bits are accumulated
                    state <= COMPLEMENT;
                end
            end
            COMPLEMENT: begin
                // Complement the accumulated bits one by one
                output_reg <= {output_reg[6:0], ~x};
                // Transition back to accumulate state after complementing all bits
                if (output_reg == 8'b1) begin
                    state <= ACCUMULATE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

// Output the current bit of the complemented number
assign z = output_reg[0];

endmodule