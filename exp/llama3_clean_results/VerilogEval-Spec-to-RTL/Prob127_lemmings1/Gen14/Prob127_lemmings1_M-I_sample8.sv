module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

// Define an enumeration for the states
typedef enum {LEFT, RIGHT} state_t;

reg [1:0] state; // Using a 2-bit state variable for one-hot encoding

// Use a single always block for sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Initialize state to LEFT
    end else begin
        case (state)
            2'b01: state <= (bump_left)? 2'b10 : 2'b01;
            2'b10: state <= (bump_right)? 2'b01 : 2'b10;
        endcase
    end
end

// Use assign statements for output logic
assign walk_left = (state == 2'b01);
assign walk_right = (state == 2'b10);

endmodule