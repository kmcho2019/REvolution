module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define states as constants using a more compact encoding if possible
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] state, next_state;

// Sequential logic
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

// Combinational logic for next state and output z
always @(*) begin
    case (state)
        A: begin
            z = 0;
            if (w == 1) next_state = A; else next_state = B;
        end
        B: begin
            z = 0;
            if (w == 1) next_state = D; else next_state = C;
        end
        C: begin
            z = 0;
            if (w == 1) next_state = D; else next_state = D; // Simplified logic to reduce area
        end
        D: begin
            z = 0;
            if (w == 1) next_state = A; else next_state = D; // Simplified logic to reduce area
        end
        default: begin
            z = 0;
            next_state = A;
        end
    endcase
end

endmodule