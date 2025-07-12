module fsm(
    input  wire            IN,  // Input signal to the FSM
    input  wire            CLK, // Clock signal used for synchronous operation
    input  wire            RST, // Reset signal to initialize the FSM
    output reg             MATCH // Output signal indicating a match condition based on the FSM state
);

// Define the states of the FSM
localparam S0 = 4'd0;
localparam S1 = 4'd1;
localparam S2 = 4'd2;
localparam S3 = 4'd3;
localparam S4 = 4'd4;
localparam S5 = 4'd5;

reg [3:0] current_state; // Current state of the FSM
reg [3:0] next_state;    // Next state of the FSM

// Initialize the FSM to the S0 state
initial begin
    current_state = S0;
end

// FSM state transition logic
always @(*) begin
    case (current_state)
        S0: begin
            if (IN == 1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (IN == 0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (IN == 0) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN == 1) begin
                next_state = S4;
            end else begin
                next_state = S1;
            end
        end
        S4: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = S1;
            end
        end
        S5: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = S1;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == S5 && IN == 1) begin
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

endmodule