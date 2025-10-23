module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values
reg [1:0] state;

// Assign output based on current state
always_comb begin
    case (state)
        2'b00, 2'b01, 2'b10: out = 0;
        2'b11: out = 1;
    endcase
end

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: state <= in? 2'b01 : 2'b00;
            2'b01: state <= in? 2'b01 : 2'b10;
            2'b10: state <= in? 2'b11 : 2'b00;
            2'b11: state <= in? 2'b01 : 2'b10;
        endcase
    end
end

endmodule