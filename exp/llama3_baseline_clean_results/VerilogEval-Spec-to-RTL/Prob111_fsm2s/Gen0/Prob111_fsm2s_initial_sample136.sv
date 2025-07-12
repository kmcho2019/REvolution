module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define states
enum logic [0:0] {OFF, ON} current_state, next_state;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (current_state)
        OFF: begin
            if (j == 1) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k == 1) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
    endcase
end

// Output generation
assign out = (current_state == ON)? 1 : 0;

endmodule