module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define the states
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

// Declare the current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Initialize the current state
initial current_state = S0;

// Asynchronous reset
always @(posedge aresetn or negedge clk) begin
    if (!aresetn) begin
        current_state <= S0;
    end else if (clk) begin
        current_state <= next_state;
    end
end

// State transition logic
always @(*) begin
    case (current_state)
        S0: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (x) begin
                next_state = S1; // Overlapping sequence
            end else begin
                next_state = S2;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1; // Found the sequence, now looking for the next '1'
            end else begin
                next_state = S0; // Sequence not found, reset
            end
        end
        default: next_state = S0;
    endcase
end

// Output logic
assign z = (current_state == S2 && x);

endmodule