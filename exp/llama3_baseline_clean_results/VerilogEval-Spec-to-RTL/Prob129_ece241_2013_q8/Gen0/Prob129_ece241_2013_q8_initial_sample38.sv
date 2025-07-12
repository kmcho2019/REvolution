module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] nextState;

// Define the states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

// Asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        state <= nextState;
    end
end

// Next state logic
always @(*) begin
    case(state)
        S0: begin
            if (x) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
        end
        S1: begin
            if (!x) begin
                nextState = S2;
            end else begin
                nextState = S1;
            end
        end
        S2: begin
            if (x) begin
                nextState = S1;
                z = 1'b1;
            end else begin
                nextState = S0;
                z = 1'b0;
            end
        end
    endcase
end

// Output logic
assign z = (state == S2 && x);

endmodule