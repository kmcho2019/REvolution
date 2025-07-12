module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Enumerate states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State register
reg [1:0] state;
reg [1:0] nextState;

// Sequential logic
always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

// Combinational logic
always @(*) begin
    case(state)
        A: nextState = in ? B : A;
        B: nextState = in ? B : C;
        C: nextState = in ? D : A;
        D: nextState = in ? B : C;
    endcase
end

// Output logic
always @(*) begin
    case(state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

endmodule