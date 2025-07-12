module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

// State encoding
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

// Output logic
assign z = (current_state == S2) && x;

// State transition logic
always @(*) begin
    case (current_state)
        S0: begin
            if (x)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (~x)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if (x)
                next_state = S1;
            else
                next_state = S2;
        end
        default: next_state = S0;
    endcase
end

// State register
always @(posedge clk or negedge aresetn) begin
    if (~aresetn)
        current_state <= S0;
    else
        current_state <= next_state;
end

endmodule