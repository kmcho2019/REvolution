module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State variable
reg [1:0] state;
reg [1:0] next_state;

// Output variable
reg out_reg;

// Determine next state
always @(*) begin
    case (state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
        default: next_state = A;
    endcase
end

// Determine output
always @(*) begin
    case (state)
        A, B, C: out_reg = 0;
        D: out_reg = 1;
        default: out_reg = 0;
    endcase
end

// State register
always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Output register
always @(posedge clk) begin
    out <= out_reg;
end

endmodule