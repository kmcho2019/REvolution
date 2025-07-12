module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding with descriptive names
    parameter [2:0] IDLE    = 3'b000;
    parameter [2:0] GRANT_0 = 3'b001;
    parameter [2:0] GRANT_1 = 3'b010;
    parameter [2:0] GRANT_2 = 3'b100;

    reg [2:0] current_state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                // Priority encoder for new grants
                if (r[0])      next_state = GRANT_0;
                else if (r[1])  next_state = GRANT_1;
                else if (r[2])  next_state = GRANT_2;
                else           next_state = IDLE;
            end
            GRANT_0: next_state = r[0] ? GRANT_0 : IDLE;
            GRANT_1: next_state = r[1] ? GRANT_1 : IDLE;
            GRANT_2: next_state = r[2] ? GRANT_2 : IDLE;
            default: next_state = IDLE;  // Safe default
        endcase
    end

    // Sequential state register
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Output assignments - direct mapping to state
    assign g = current_state;

endmodule