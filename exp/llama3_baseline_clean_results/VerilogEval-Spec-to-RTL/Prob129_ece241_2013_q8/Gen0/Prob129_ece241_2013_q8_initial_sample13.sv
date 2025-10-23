module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

reg [1:0] current_state, next_state;

// State register with asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case(current_state)
        S0: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (~x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1; // Because we are recognizing overlapping sequences
            end else begin
                next_state = S0;
            end
        end
    endcase
end

// Output logic
assign z = (current_state == S2) && x;

endmodule