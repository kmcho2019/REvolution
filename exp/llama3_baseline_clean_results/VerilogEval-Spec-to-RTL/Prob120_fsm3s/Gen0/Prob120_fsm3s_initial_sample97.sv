module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
reg [1:0] state;
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        case (state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
        endcase
    end
end

always @(posedge clk) begin
    case (state)
        A, B, C: out <= 1'b0;
        D: out <= 1'b1;
    endcase
end

endmodule