module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// Define state registers
reg [1:0] state;

// Define one-hot encoding
localparam A = 2'b01;
localparam B = 2'b10;

// Define next state logic
reg [1:0] next_state;

// Define output logic
always @(*) begin
    case(state)
        A: z = ~x;
        B: z = ~x;
        default: z = 1'bx; // Handle unknown states
    endcase
end

// Define state transition logic
always @(*) begin
    case(state)
        A: next_state = (x == 1'b0) ? A : B;
        B: next_state = (x == 1'b0) ? B : B;
        default: next_state = A; // Handle unknown states
    endcase
end

// Define sequential logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule