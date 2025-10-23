module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state
reg z_reg; // Output register

// Combinational logic for next state and output
always @(*) begin
    case (y)
        3'b000: begin
            next_y = (x == 0)? 3'b000 : 3'b001;
            z_reg = 0;
        end
        3'b001: begin
            next_y = (x == 0)? 3'b001 : 3'b100;
            z_reg = 0;
        end
        3'b010: begin
            next_y = (x == 0)? 3'b010 : 3'b001;
            z_reg = 0;
        end
        3'b011: begin
            next_y = (x == 0)? 3'b001 : 3'b010;
            z_reg = 1;
        end
        3'b100: begin
            next_y = (x == 0)? 3'b011 : 3'b100;
            z_reg = 1;
        end
        default: begin
            next_y = 3'b000; // Default next state
            z_reg = 0; // Default output
        end
    endcase
end

// Sequential logic for state and output registers
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Reset to state 000
        z <= 0; // Reset output to 0
    end else begin
        y <= next_y; // Update current state
        z <= z_reg; // Update output
    end
end

endmodule