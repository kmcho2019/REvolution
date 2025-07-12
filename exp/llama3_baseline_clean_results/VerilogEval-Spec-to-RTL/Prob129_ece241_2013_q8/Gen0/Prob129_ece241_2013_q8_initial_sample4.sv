module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

// Define the states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

// Define the current state
reg [1:0] current_state;
reg [1:0] next_state;

// Initialize the current state to S0
initial current_state = S0;

// Asynchronous reset
always @(negedge aresetn) begin
    current_state <= S0;
end

// Synchronous logic
always @(posedge clk) begin
    current_state <= next_state;
end

// Combinational logic
always @(*) begin
    case (current_state)
        S0: begin
            if (x == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
            z = 1'b0;
        end
        S1: begin
            if (x == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
            z = 1'b0;
        end
        S2: begin
            if (x == 1'b1) begin
                next_state = S1;
                z = 1'b1;
            end else begin
                next_state = S0;
                z = 1'b0;
            end
        end
        default: begin
            next_state = S0;
            z = 1'b0;
        end
    endcase
end

endmodule