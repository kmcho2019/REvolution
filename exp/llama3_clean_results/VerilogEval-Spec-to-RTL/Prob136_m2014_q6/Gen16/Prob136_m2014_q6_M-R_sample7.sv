module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using binary encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the state register using binary encoding
reg [2:0] state;

// Sequential logic for state transition and output
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        z <= 0;
    end else begin
        case (state)
            A: if (w) state <= A; else state <= B;
            B: if (w) state <= D; else state <= C;
            C: if (w) state <= D; else state <= E;
            D: if (w) state <= A; else state <= F;
            E: if (w) state <= D; else state <= E;
            F: if (w) state <= D; else state <= C;
            default: state <= A;
        endcase
        // Combinational logic for output z
        z <= (state == E) || (state == F);
    end
end

endmodule