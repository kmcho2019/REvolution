module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
reg [1:0] current_state;
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Output logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
        out <= 1'b0;
    end else begin
        case (current_state)
            A: begin
                current_state <= in? B : A;
                out <= 1'b0;
            end
            B: begin
                current_state <= in? B : C;
                out <= 1'b0;
            end
            C: begin
                current_state <= in? D : A;
                out <= 1'b0;
            end
            D: begin
                current_state <= in? B : C;
                out <= 1'b1;
            end
        endcase
    end
end

endmodule