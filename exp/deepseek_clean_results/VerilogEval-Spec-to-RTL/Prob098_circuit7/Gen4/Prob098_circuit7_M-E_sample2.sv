module TopModule (
    input clk,
    input a,
    output reg q
);

// Define states
localparam Q_HIGH = 1'b1;
localparam Q_LOW = 1'b0;

// State register
reg state;

always @(posedge clk) begin
    case (state)
        Q_HIGH: state <= a ? Q_LOW : Q_HIGH;
        Q_LOW: state <= a ? Q_LOW : Q_HIGH;
    endcase
end

// Output assignment
always @(*) begin
    q = state;
end

endmodule