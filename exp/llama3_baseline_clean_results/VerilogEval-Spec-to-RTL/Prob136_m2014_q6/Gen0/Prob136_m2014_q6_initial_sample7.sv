module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state; // 3-bit state register
reg [2:0] nextState; // 3-bit next state register
reg z_reg; // output register

// Initialize state to A (0) on reset
initial begin
    state = 3'b000; // A
    z_reg = 1'b0;
end

// Update state on positive edge of clock
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset state to A (0)
        z_reg <= 1'b0;
    end else begin
        state <= nextState;
    end
end

// Determine next state and output
always @(*) begin
    case (state)
        3'b000: // A
            if (w) begin
                nextState = 3'b000; // A
                z_reg = 1'b0;
            end else begin
                nextState = 3'b001; // B
                z_reg = 1'b0;
            end
        3'b001: // B
            if (w) begin
                nextState = 3'b011; // D
                z_reg = 1'b0;
            end else begin
                nextState = 3'b010; // C
                z_reg = 1'b0;
            end
        3'b010: // C
            if (w) begin
                nextState = 3'b011; // D
                z_reg = 1'b0;
            end else begin
                nextState = 3'b100; // E
                z_reg = 1'b1;
            end
        3'b011: // D
            if (w) begin
                nextState = 3'b000; // A
                z_reg = 1'b0;
            end else begin
                nextState = 3'b101; // F
                z_reg = 1'b1;
            end
        3'b100: // E
            if (w) begin
                nextState = 3'b011; // D
                z_reg = 1'b0;
            end else begin
                nextState = 3'b100; // E
                z_reg = 1'b1;
            end
        3'b101: // F
            if (w) begin
                nextState = 3'b011; // D
                z_reg = 1'b0;
            end else begin
                nextState = 3'b010; // C
                z_reg = 1'b0;
            end
        default: begin
            nextState = 3'b000; // A
            z_reg = 1'b0;
        end
    endcase
end

// Assign output
assign z = z_reg;

endmodule