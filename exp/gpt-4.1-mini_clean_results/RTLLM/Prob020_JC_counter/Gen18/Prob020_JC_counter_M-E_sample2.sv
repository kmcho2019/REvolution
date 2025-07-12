module JC_counter (
    input  wire        clk,
    input  wire        rst_n,
    output wire [63:0] Q
);

reg [31:0] Q_hi;
reg [31:0] Q_lo;

wire msb_hi_next;
wire msb_lo_next;

// Calculate next MSBs for Q_hi and Q_lo as complements of their LSBs of the opposite half
assign msb_hi_next = ~Q_lo[0];
assign msb_lo_next = ~Q_hi[0];

// Next states for each half shift register with torsional feedback from the other half
wire [31:0] Q_hi_next = {msb_hi_next, Q_hi[31:1]};
wire [31:0] Q_lo_next = {msb_lo_next, Q_lo[31:1]};

// Concatenate outputs as Q[63:32] = Q_hi, Q[31:0] = Q_lo
assign Q = {Q_hi, Q_lo};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q_hi <= 32'b0;
        Q_lo <= 32'b0;
    end else begin
        Q_hi <= Q_hi_next;
        Q_lo <= Q_lo_next;
    end
end

endmodule