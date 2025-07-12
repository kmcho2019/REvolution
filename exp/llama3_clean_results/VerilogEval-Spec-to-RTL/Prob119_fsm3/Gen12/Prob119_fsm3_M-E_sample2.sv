module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State registers
reg msb; // Most significant bit
reg lsb; // Least significant bit

// Next state logic
wire msb_next;
wire lsb_next;

assign msb_next = (msb && lsb && ~in) || (~msb && lsb && ~in) || (~msb && ~lsb && in);
assign lsb_next = (msb && ~lsb && in) || (~msb && lsb) || (~msb && ~lsb && ~in);

// Output logic
assign out = msb && lsb;

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) begin
        msb <= 0;
        lsb <= 1;
    end else if (in || ~in) begin // Clock-gating
        msb <= msb_next;
        lsb <= lsb_next;
    end
end

endmodule