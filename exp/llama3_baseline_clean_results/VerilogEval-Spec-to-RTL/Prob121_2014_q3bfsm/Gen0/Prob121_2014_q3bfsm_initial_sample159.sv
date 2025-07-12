module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state
reg z_next; // Next output z

// Combinational logic for next state and output z
always @(*) begin
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
        default: begin
            next_y = 3'b000; // Default next state
            z_next = 1'b0;
        end
    endcase
end

// Sequential logic for state and output z
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Synchronous reset
        z <= 1'b0;
    end else begin
        y <= next_y;
        z <= z_next;
    end
end

endmodule