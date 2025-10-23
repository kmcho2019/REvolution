module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

// Current state and next state
reg [1:0] curr_state;
reg [1:0] next_state;

// Output
assign z = (curr_state == S2) && x;

// State transition logic
always @(*) begin
    case (curr_state)
        S0: begin
            if (x)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (!x)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if (x)
                next_state = S1;
            else
                next_state = S0;
        end
    endcase
end

// Sequential logic
always @(posedge clk or negedge aresetn) begin
    if (!aresetn)
        curr_state <= S0;
    else
        curr_state <= next_state;
end

endmodule