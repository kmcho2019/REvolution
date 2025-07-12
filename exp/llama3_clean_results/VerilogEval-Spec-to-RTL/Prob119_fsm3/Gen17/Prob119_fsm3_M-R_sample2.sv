module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values using one-hot encoding
localparam A = 2'b01;
localparam B = 2'b10;
localparam C = 2'b11;
localparam D = 2'b00;

// State register
reg [1:0] state;

// Output logic
assign out = (state == D) ? 1'b1 : 1'b0;

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else if (state == A) begin
        state <= in ? B : A;
    end else if (state == B) begin
        state <= in ? B : C;
    end else if (state == C) begin
        state <= in ? D : A;
    end else if (state == D) begin
        state <= in ? B : C;
    end else begin
        state <= A; // Default state
    end
end

endmodule