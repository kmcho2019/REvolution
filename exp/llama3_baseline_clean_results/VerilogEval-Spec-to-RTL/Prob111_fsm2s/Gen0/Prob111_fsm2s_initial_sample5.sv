module TopModule (
    input         clk,
    input         reset,
    input         j,
    input         k,
    output        out
);

// Define the states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Declare the current and next state
reg   curr_state;
reg   next_state;

// State register
always @(posedge clk or posedge reset) begin
    if (reset) begin
        curr_state <= OFF;
    end else begin
        curr_state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    case (curr_state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: begin
            next_state = OFF; // Default to OFF for unknown states
        end
    endcase
end

// Output logic (Moore machine, output depends only on the state)
assign out = curr_state;

endmodule