module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

// Define the current state register
reg [2:0] y;
// Output variable
reg z;

// Combinational logic for next state and output
always @(*) begin
    // Default next state and output (can be optimized further based on the table)
    reg [2:0] next_y;
    reg z_next;

    case (y)
        3'b000: begin
            next_y = x ? 3'b001 : 3'b000;
            z_next = 1'b0;
        end
        3'b001: begin
            next_y = x ? 3'b100 : 3'b001;
            z_next = 1'b0;
        end
        3'b010: begin
            next_y = x ? 3'b001 : 3'b010;
            z_next = 1'b0;
        end
        3'b011: begin
            next_y = x ? 3'b010 : 3'b001;
            z_next = 1'b1;
        end
        3'b100: begin
            next_y = x ? 3'b100 : 3'b011;
            z_next = 1'b1;
        end
        default: begin // For states not explicitly defined
            next_y = y; // Stay in the same state
            z_next = 1'b0; // Default output for undefined states
        end
    endcase

    // Assign next state and output
    if (reset) begin
        y = 3'b000;
        z = 1'b0;
    end else begin
        z = z_next;
    end
end

// Sequential logic for updating the current state
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        case (y)
            3'b000: y <= x ? 3'b001 : 3'b000;
            3'b001: y <= x ? 3'b100 : 3'b001;
            3'b010: y <= x ? 3'b001 : 3'b010;
            3'b011: y <= x ? 3'b010 : 3'b001;
            3'b100: y <= x ? 3'b100 : 3'b011;
            default: y <= y; // Stay in the same state for undefined states
        endcase
    end
end

endmodule