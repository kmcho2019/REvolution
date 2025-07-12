module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state, next_state;

// Define states
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        S0: begin
            if (x) begin
                next_state <= S1;
            end else begin
                next_state <= S0;
            end
        end
        S1: begin
            if (!x) begin
                next_state <= S2;
            end else begin
                next_state <= S1;
            end
        end
        S2: begin
            if (x) begin
                next_state <= S1;
                z <= 1'b1; // Assert z when '101' sequence is detected
            end else begin
                next_state <= S0;
            end
        end
        default: next_state <= S0;
    endcase
end

always @(*) begin
    case (state)
        S0: z <= 1'b0;
        S1: z <= 1'b0;
        S2: begin
            if (x) begin
                // Do nothing, let z be asserted from previous state
            end else begin
                z <= 1'b0;
            end
        end
        default: z <= 1'b0;
    endcase
end

endmodule