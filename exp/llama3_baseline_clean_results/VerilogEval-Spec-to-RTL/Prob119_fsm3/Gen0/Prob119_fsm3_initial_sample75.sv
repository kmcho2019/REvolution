module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State register
reg [1:0] state;
reg [1:0] next_state;

// Output logic
always @(state) begin
    case(state)
        A: out <= 1'b0;
        B: out <= 1'b0;
        C: out <= 1'b0;
        D: out <= 1'b1;
        default: out <= 1'b0;
    endcase
end

// State transition logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A;
    end else begin
        case(state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
            default: state <= A;
        endcase
    end
end

endmodule