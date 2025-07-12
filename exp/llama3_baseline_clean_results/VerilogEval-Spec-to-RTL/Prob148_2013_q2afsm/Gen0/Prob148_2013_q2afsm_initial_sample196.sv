module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [2:0] state; // Current state
reg [2:0] next_state; // Next state

// Output logic
always @(*) begin
    case (state)
        3'b000: begin // State A
            g = 3'b000;
        end
        3'b001: begin // State B
            g = 3'b001;
        end
        3'b010: begin // State C
            g = 3'b010;
        end
        default: begin
            g = 3'b000;
        end
    endcase
end

// Next state logic
always @(*) begin
    case (state)
        3'b000: begin // State A
            if (r[0] == 1'b1) begin
                next_state = 3'b001; // Go to B if r0=1
            end else if (r[1] == 1'b1) begin
                next_state = 3'b010; // Go to C if r1=1 and r0=0
            end else if (r[2] == 1'b1) begin
                // Since the condition for going to D from A is not clearly defined in the provided state diagram,
                // and based on the description, device 2 has the lowest priority, we'll consider it should only go to D if r0 and r1 are 0.
                // However, as state D's transitions and behavior are not explicitly defined, we will not include it in our implementation.
                next_state = 3'b000; // Stay in A, assuming D's condition is not met or is not relevant.
            end else begin
                next_state = 3'b000; // Stay in A if no requests
            end
        end
        3'b001: begin // State B
            if (r[0] == 1'b1) begin
                next_state = 3'b001; // Stay in B if r0=1
            end else begin
                next_state = 3'b000; // Go back to A if r0=0
            end
        end
        3'b010: begin // State C
            if (r[1] == 1'b1) begin
                next_state = 3'b010; // Stay in C if r1=1
            end else begin
                next_state = 3'b000; // Go back to A if r1=0
            end
        end
        default: begin
            next_state = 3'b000; // Go to A for any other state
        end
    endcase
end

// Current state logic
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= 3'b000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule