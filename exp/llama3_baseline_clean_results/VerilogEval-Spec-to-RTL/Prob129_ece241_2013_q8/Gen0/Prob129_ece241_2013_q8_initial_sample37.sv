module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state; // Current state: 2 bits to represent 3 states (S0, S1, S2)
reg [1:0] nextState; // Next state

// Define states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

// Assign initial values
initial state = S0;

// Asynchronous reset
always @(posedge aresetn or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
    end
end

// Synchronous logic
always @(posedge clk) begin
    if (aresetn) begin
        case (state)
            S0: begin
                if (x == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            S1: begin
                if (x == 1'b0) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
            end
            S2: begin
                if (x == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            default: state <= S0;
        endcase
    end
end

// Mealy-type output logic
always @(posedge clk) begin
    case (state)
        S2: z <= x;
        default: z <= 1'b0;
    endcase
end

endmodule