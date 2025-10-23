module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

// State definitions
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

// Current and next state variables
reg [1:0] current_state;
reg [1:0] next_state;

// Initialize output
always @(posedge clk) begin
    if (!aresetn) begin
        // Asynchronous reset
        z <= 1'b0;
    end else begin
        z <= (current_state == S2 && x == 1'b1) ? 1'b1 : 1'b0;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        S0: begin
            if (x == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (x == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x == 1'b1) begin
                next_state = S1;
            end else if (x == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S2;
            end
        end
        default: next_state = S0;
    endcase
end

// Current state update
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Asynchronous reset
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

endmodule