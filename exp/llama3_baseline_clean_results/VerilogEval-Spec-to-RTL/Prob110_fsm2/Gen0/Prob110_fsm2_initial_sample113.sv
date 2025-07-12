module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [0:0] state; // Current state (OFF=0, ON=1)
reg [0:0] nextState; // Next state
reg outReg; // Output register

// Output logic (Moore machine)
always @(*) begin
    case(state)
        0: outReg = 0; // State OFF
        1: outReg = 1; // State ON
        default: outReg = 0;
    endcase
end

// State transition logic
always @(*) begin
    case(state)
        0: begin // State OFF
            if(j) begin
                nextState = 1; // Transition to ON if j=1
            end else begin
                nextState = 0; // Stay in OFF if j=0
            end
        end
        1: begin // State ON
            if(k) begin
                nextState = 0; // Transition to OFF if k=1
            end else begin
                nextState = 1; // Stay in ON if k=0
            end
        end
        default: nextState = 0;
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        state <= nextState; // Update state
    end
end

// Output assignment
assign out = outReg;

endmodule