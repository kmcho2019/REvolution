module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

// State encoding
localparam HOLD   = 2'b00;
localparam RESET  = 2'b01;
localparam SET    = 2'b10;
localparam TOGGLE = 2'b11;

always @(posedge clk) begin
    case ({j, k})
        HOLD:   Q <= Q;          // No change
        RESET:  Q <= 1'b0;       // Reset
        SET:    Q <= 1'b1;       // Set
        TOGGLE: Q <= ~Q;         // Toggle
    endcase
end

endmodule