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

// LUT for next-state and output values
reg [1:0] next_state;
reg out_reg;
always @(*) begin
    case (state)
        A: begin
            if (in) begin
                next_state = B;
                out_reg = 0;
            end else begin
                next_state = A;
                out_reg = 0;
            end
        end
        B: begin
            if (in) begin
                next_state = B;
                out_reg = 0;
            end else begin
                next_state = C;
                out_reg = 0;
            end
        end
        C: begin
            if (in) begin
                next_state = D;
                out_reg = 0;
            end else begin
                next_state = A;
                out_reg = 0;
            end
        end
        D: begin
            if (in) begin
                next_state = B;
                out_reg = 1;
            end else begin
                next_state = C;
                out_reg = 1;
            end
        end
    endcase
end

// Output logic
assign out = out_reg;

// Sequential logic for state transition with clock gating
reg clk_enable;
assign clk_enable = 1; // Clock enable signal (always high in this example)
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else if (clk_enable) begin
        state <= next_state;
    end
end

endmodule