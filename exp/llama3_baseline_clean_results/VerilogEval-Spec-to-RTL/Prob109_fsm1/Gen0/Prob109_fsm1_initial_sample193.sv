module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] current_state; // 1-bit signal to represent the current state
reg [0:0] next_state;    // 1-bit signal to represent the next state

// Assign out based on the current state (Moore machine)
assign out = current_state;

// Next state logic based on the given state transition diagram
always @(*) begin
    case (current_state)
        1'b0: begin // State A
            if (~in) begin
                next_state = 1'b1; // A (0) --0--> B
            end else begin
                next_state = 1'b0; // A (0) --1--> A
            end
        end
        1'b1: begin // State B
            if (~in) begin
                next_state = 1'b0; // B (1) --0--> A
            end else begin
                next_state = 1'b1; // B (1) --1--> B
            end
        end
    endcase
end

// Synchronous update of the current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b1; // Asynchronous reset to state B
    end else begin
        current_state <= next_state;
    end
end

endmodule