module fsm(
    input IN, 
    input CLK, 
    input RST, 
    output reg MATCH
);

// Define states
localparam IDLE = 5'd0;
localparam S1 = 5'd1;
localparam S2 = 5'd2;
localparam S3 = 5'd3;
localparam S4 = 5'd4;
localparam S5 = 5'd5;

// Current state and next state
reg [4:0] current_state;
reg [4:0] next_state;

// Initialize current state
initial current_state = IDLE;

// Combinational logic for next state
always @(*) begin
    case(current_state)
        IDLE: 
            if (IN == 1'b1 && RST == 1'b0) 
                next_state = S1;
            else if (RST == 1'b1) 
                next_state = IDLE;
            else 
                next_state = IDLE;
        S1: 
            if (IN == 1'b0 && RST == 1'b0) 
                next_state = S2;
            else if (RST == 1'b1) 
                next_state = IDLE;
            else 
                next_state = S1;
        S2: 
            if (IN == 1'b1 && RST == 1'b0) 
                next_state = S3;
            else if (IN == 1'b0 && RST == 1'b0) 
                next_state = S2;
            else if (RST == 1'b1) 
                next_state = IDLE;
            else 
                next_state = S2;
        S3: 
            if (IN == 1'b1 && RST == 1'b0) 
                next_state = S4;
            else if (RST == 1'b1) 
                next_state = IDLE;
            else 
                next_state = S3;
        S4: 
            if (IN == 1'b1 && RST == 1'b0) 
                next_state = S5;
            else if (RST == 1'b1) 
                next_state = IDLE;
            else 
                next_state = S4;
        S5: 
            if (RST == 1'b1) 
                next_state = IDLE;
            else 
                next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Sequential logic for current state
always @(posedge CLK or posedge RST) begin
    if (RST == 1'b1) 
        current_state <= IDLE;
    else 
        current_state <= next_state;
end

// Output logic
always @(*) begin
    if (current_state == S5) 
        MATCH = 1'b1;
    else 
        MATCH = 1'b0;
end

endmodule