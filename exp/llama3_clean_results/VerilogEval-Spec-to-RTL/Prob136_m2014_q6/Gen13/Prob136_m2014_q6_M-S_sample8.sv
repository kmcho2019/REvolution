module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using gray code encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b011;
parameter D = 3'b010;
parameter E = 3'b110;
parameter F = 3'b111;

// State register
reg [2:0] state;
reg [2:0] next_state;

// Combinational logic for next state and output z
always @(*) begin
    case (state)
        A: begin next_state = w? A : B; z = 0; end
        B: begin next_state = w? D : C; z = 0; end
        C: begin next_state = w? D : E; z = 0; end
        D: begin next_state = w? A : F; z = 0; end
        E: begin next_state = w? D : E; z = 1; end
        F: begin next_state = w? D : C; z = 1; end
        default: begin next_state = A; z = 0; end
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) state <= A;
    else state <= next_state;
end

endmodule