module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state, next_state;

// State encoding: S0 = 2'b00, S1 = 2'b01, S2 = 2'b10
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        S0: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
            z = 1'b0;  // Default z to 0
        end
        S1: begin
            if (~x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
            z = 1'b0;  // Default z to 0
        end
        S2: begin
            if (x) begin
                next_state = S1;
                z = 1'b1;  // Assert z to 1 on detecting '101'
            end else begin
                next_state = S0;
                z = 1'b0;  // Default z to 0
            end
        end
        default: begin
            next_state = S0;
            z = 1'b0;
        end
    endcase
end

endmodule