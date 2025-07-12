module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter A = 2'd0;
parameter B = 2'd1;
parameter C = 2'd2;
parameter D = 2'd3;

// Define the state register
reg [1:0] state;

// Sequential logic for state update with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= {1'b0, in};
            B: state <= {~in, in};
            C: state <= {~in, ~in};
            D: state <= {~in, in};
            default: state <= A;
        endcase
    end
end

// Output logic using LUTs
reg [1:0] next_state;
reg out_lut;

always @(*) begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

always @(*) begin
    case (state)
        A: out_lut = 1'b0;
        B: out_lut = 1'b0;
        C: out_lut = 1'b0;
        D: out_lut = 1'b1;
        default: out_lut = 1'b0;
    endcase
end

assign out = out_lut;

endmodule