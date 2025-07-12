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

reg [1:0] state;

always @(posedge clk) begin
    case ({j, k})
        2'b00: state <= HOLD;
        2'b01: state <= RESET;
        2'b10: state <= SET;
        2'b11: state <= TOGGLE;
    endcase

    case (state)
        HOLD:   Q <= Q;
        RESET:  Q <= 1'b0;
        SET:    Q <= 1'b1;
        TOGGLE: Q <= ~Q;
    endcase
end

endmodule