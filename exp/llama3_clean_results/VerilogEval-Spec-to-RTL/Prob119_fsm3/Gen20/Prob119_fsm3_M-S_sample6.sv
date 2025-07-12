module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values using binary encoding
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State register
reg [1:0] state;

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
        out <= 0;
    end else begin
        case (state)
            A: if (!in) state <= A; else state <= B;
            B: if (!in) state <= C; else state <= B;
            C: if (!in) state <= A; else state <= D;
            D: if (!in) state <= C; else state <= B;
        endcase
        case (state)
            A, B, C: out <= 0;
            D: out <= 1;
        endcase
    end
end

endmodule