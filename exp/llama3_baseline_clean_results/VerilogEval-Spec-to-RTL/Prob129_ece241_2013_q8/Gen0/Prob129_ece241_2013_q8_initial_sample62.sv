module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

// Define the states
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

reg [1:0] current_state;
reg [1:0] next_state;

// Initialize the current state to S0
initial begin
    current_state = S0;
end

// Asynchronous reset
always @(negedge aresetn) begin
    current_state <= S0;
end

// Mealy machine logic
always @(*) begin
    next_state = current_state;
    z = 1'b0;
    
    case (current_state)
        S0: begin
            if (x == 1'b1) begin
                next_state = S1;
            end
        end
        S1: begin
            if (x == 1'b0) begin
                next_state = S2;
            end else if (x == 1'b1) begin
                next_state = S1;
            end
        end
        S2: begin
            if (x == 1'b1) begin
                z = 1'b1;
                next_state = S1;
            end else if (x == 1'b0) begin
                next_state = S0;
            end
        end
    endcase
end

// Synchronous update of the current state
always @(posedge clk) begin
    current_state <= next_state;
end

endmodule