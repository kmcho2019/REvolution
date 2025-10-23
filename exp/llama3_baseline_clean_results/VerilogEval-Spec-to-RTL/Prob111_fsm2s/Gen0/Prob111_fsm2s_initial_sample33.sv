module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] state; // current state, initialized to OFF
reg [0:0] nextState; // next state

// state encoding: OFF = 0, ON = 1
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// output logic
assign out = (state == ON) ? 1'b1 : 1'b0;

// next state logic
always @(*) begin
    case(state)
        OFF: begin
            if(j) begin
                nextState = ON;
            end else begin
                nextState = OFF;
            end
        end
        ON: begin
            if(k) begin
                nextState = OFF;
            end else begin
                nextState = ON;
            end
        end
        default: nextState = OFF;
    endcase
end

// state update
always @(posedge clk) begin
    if(reset) begin
        state <= OFF; // reset to OFF
    end else begin
        state <= nextState;
    end
end

endmodule