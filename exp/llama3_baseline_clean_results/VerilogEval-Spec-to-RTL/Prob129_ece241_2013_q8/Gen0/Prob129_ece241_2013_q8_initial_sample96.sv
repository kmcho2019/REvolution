module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define the states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

// Declare the current and next state variables
reg [1:0] current_state;
reg [1:0] next_state;

// Assign the output z based on the current state and input x
assign z = (current_state == S2 && x == 1) ? 1'b1 : 1'b0;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        S0: begin
            if (x == 1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (x == 0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x == 1) begin
                next_state = S1;
            end else begin
                next_state = S2;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

endmodule