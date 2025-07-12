module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
localparam [2:0] A = 3'b000;
localparam [2:0] B = 3'b001;
localparam [2:0] C = 3'b010;
localparam [2:0] D = 3'b011;
localparam [2:0] E = 3'b100;
localparam [2:0] F = 3'b101;

// State register
reg [2:0] current_state;
reg [2:0] next_state;

// State register always block
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table always block
always @(*) begin
    case (current_state)
        A: next_state = (w) ? B : A;
        B: next_state = (w) ? C : D;
        C: next_state = (w) ? E : D;
        D: next_state = (w) ? F : A;
        E: next_state = (w) ? E : D;
        F: next_state = (w) ? C : D;
        default: next_state = A; // Handle invalid states
    endcase
end

// Output z is 1 when in states E or F, 0 otherwise
assign z = (current_state == E) || (current_state == F);

endmodule