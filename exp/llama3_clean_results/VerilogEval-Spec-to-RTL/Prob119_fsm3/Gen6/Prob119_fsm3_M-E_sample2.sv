module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter A = 4'd1;
parameter B = 4'd2;
parameter C = 4'd4;
parameter D = 4'd8;

// Current state variable
reg [3:0] current_state;

// Initialize current state with parameter A
initial current_state = A;

// Synchronous reset and sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= in ? B : A;
            B: current_state <= in ? B : C;
            C: current_state <= in ? D : A;
            D: current_state <= in ? B : C;
            default: current_state <= A;
        endcase
    end
end

// Combinational logic to determine output
assign out = (current_state == D) ? 1'd1 : 1'd0;

endmodule