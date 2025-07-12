module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] current_state; // 1-bit register to store the current state (A or B)
reg [0:0] next_state;   // 1-bit register to store the next state (A or B)

// Define the states
localparam B = 1'b1; // State B
localparam A = 1'b0; // State A

// Output based on the current state
assign out = (current_state == B) ? 1'b1 : 1'b0; // out = 1 when state is B, else out = 0

// Determine the next state based on the current state and the input
always @(*) begin
    case(current_state)
        B: begin
            if(in == 1'b0) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        A: begin
            if(in == 1'b0) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
    endcase
end

// Synchronous reset
always @(posedge clk) begin
    if(reset == 1'b1) begin
        current_state <= B; // Reset to state B
    end else begin
        current_state <= next_state; // Update the current state
    end
end

endmodule