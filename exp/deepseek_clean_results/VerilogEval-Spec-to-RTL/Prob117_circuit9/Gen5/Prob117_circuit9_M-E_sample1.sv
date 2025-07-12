module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// One-hot encoded states for q values 0-6
localparam [6:0] Q0 = 7'b0000001;
localparam [6:0] Q1 = 7'b0000010;
localparam [6:0] Q2 = 7'b0000100;
localparam [6:0] Q3 = 7'b0001000;
localparam [6:0] Q4 = 7'b0010000;
localparam [6:0] Q5 = 7'b0100000;
localparam [6:0] Q6 = 7'b1000000;

reg [6:0] state, next_state;

// Initialize to Q4 (q=4)
initial begin
    state = Q4;
    q = 3'b100;
end

// State transition logic
always @(*) begin
    if (a) begin
        next_state = state;  // Hold current state when a=1
    end else begin
        case (state)
            Q0: next_state = Q1;
            Q1: next_state = Q2;
            Q2: next_state = Q3;
            Q3: next_state = Q4;
            Q4: next_state = Q5;
            Q5: next_state = Q6;
            Q6: next_state = Q0;
            default: next_state = Q4;
        endcase
    end
end

// State register and output logic
always @(posedge clk) begin
    state <= next_state;
    
    case (next_state)
        Q0: q <= 3'b000;
        Q1: q <= 3'b001;
        Q2: q <= 3'b010;
        Q3: q <= 3'b011;
        Q4: q <= 3'b100;
        Q5: q <= 3'b101;
        Q6: q <= 3'b110;
        default: q <= 3'b100;
    endcase
end

endmodule