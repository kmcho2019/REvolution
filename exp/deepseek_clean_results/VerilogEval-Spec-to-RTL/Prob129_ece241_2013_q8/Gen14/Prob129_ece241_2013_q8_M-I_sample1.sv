module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // One-hot state encoding
    localparam S0 = 2'b01;  // Initial state
    localparam S1 = 2'b10;  // Received '1'
    localparam S2 = 2'b11;  // Received '10'
    
    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // State register with async reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Registered Mealy output
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            z <= 1'b0;
        end else begin
            z <= (state == S2) && x;
        end
    end

endmodule